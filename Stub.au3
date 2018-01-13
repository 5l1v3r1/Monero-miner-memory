
Func _arrayadd(ByRef $avarray, $vvalue)
	If NOT IsArray($avarray) Then Return SetError(1, 0, -1)
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, -1)
	Local $iubound = UBound($avarray)
	ReDim $avarray[$iubound + 1]
	$avarray[$iubound] = $vvalue
	Return $iubound
EndFunc

Func _arraybinarysearch(Const ByRef $avarray, $vvalue, $istart = 0, $iend = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, -1)
	If UBound($avarray, 0) <> 1 Then Return SetError(5, 0, -1)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(4, 0, -1)
	Local $imid = Int(($iend + $istart) / 2)
	If $avarray[$istart] > $vvalue OR $avarray[$iend] < $vvalue Then Return SetError(2, 0, -1)
	While $istart <= $imid AND $vvalue <> $avarray[$imid]
		If $vvalue < $avarray[$imid] Then
			$iend = $imid - 1
		Else
			$istart = $imid + 1
		EndIf
		$imid = Int(($iend + $istart) / 2)
	WEnd
	If $istart > $iend Then Return SetError(3, 0, -1)
	Return $imid
EndFunc

Func _arraycombinations(ByRef $avarray, $iset, $sdelim = "")
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, 0)
	Local $in = UBound($avarray)
	Local $ir = $iset
	Local $aidx[$ir]
	For $i = 0 To $ir - 1
		$aidx[$i] = $i
	Next
	Local $itotal = __array_combinations($in, $ir)
	Local $ileft = $itotal
	Local $aresult[$itotal + 1]
	$aresult[0] = $itotal
	Local $icount = 1
	While $ileft > 0
		__array_getnext($in, $ir, $ileft, $itotal, $aidx)
		For $i = 0 To $iset - 1
			$aresult[$icount] &= $avarray[$aidx[$i]] & $sdelim
		Next
		If $sdelim <> "" Then $aresult[$icount] = StringTrimRight($aresult[$icount], 1)
		$icount += 1
	WEnd
	Return $aresult
EndFunc

Func _arrayconcatenate(ByRef $avarraytarget, Const ByRef $avarraysource, $istart = 0)
	If NOT IsArray($avarraytarget) Then Return SetError(1, 0, 0)
	If NOT IsArray($avarraysource) Then Return SetError(2, 0, 0)
	If UBound($avarraytarget, 0) <> 1 Then
		If UBound($avarraysource, 0) <> 1 Then Return SetError(5, 0, 0)
		Return SetError(3, 0, 0)
	EndIf
	If UBound($avarraysource, 0) <> 1 Then Return SetError(4, 0, 0)
	Local $iuboundtarget = UBound($avarraytarget) - $istart, $iuboundsource = UBound($avarraysource)
	ReDim $avarraytarget[$iuboundtarget + $iuboundsource]
	For $i = $istart To $iuboundsource - 1
		$avarraytarget[$iuboundtarget + $i] = $avarraysource[$i]
	Next
	Return $iuboundtarget + $iuboundsource
EndFunc

Func _arraycreate($v_0, $v_1 = 0, $v_2 = 0, $v_3 = 0, $v_4 = 0, $v_5 = 0, $v_6 = 0, $v_7 = 0, $v_8 = 0, $v_9 = 0, $v_10 = 0, $v_11 = 0, $v_12 = 0, $v_13 = 0, $v_14 = 0, $v_15 = 0, $v_16 = 0, $v_17 = 0, $v_18 = 0, $v_19 = 0, $v_20 = 0)
	Local $av_array[21] = [$v_0, $v_1, $v_2, $v_3, $v_4, $v_5, $v_6, $v_7, $v_8, $v_9, $v_10, $v_11, $v_12, $v_13, $v_14, $v_15, $v_16, $v_17, $v_18, $v_19, $v_20]
	ReDim $av_array[@NumParams]
	Return $av_array
EndFunc

Func _arraydelete(ByRef $avarray, $ielement)
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	Local $iubound = UBound($avarray, 1) - 1
	If NOT $iubound Then
		$avarray = ""
		Return 0
	EndIf
	If $ielement < 0 Then $ielement = 0
	If $ielement > $iubound Then $ielement = $iubound
	Switch UBound($avarray, 0)
		Case 1
			For $i = $ielement To $iubound - 1
				$avarray[$i] = $avarray[$i + 1]
			Next
			ReDim $avarray[$iubound]
		Case 2
			Local $isubmax = UBound($avarray, 2) - 1
			For $i = $ielement To $iubound - 1
				For $j = 0 To $isubmax
					$avarray[$i][$j] = $avarray[$i + 1][$j]
				Next
			Next
			ReDim $avarray[$iubound][$isubmax + 1]
		Case Else
			Return SetError(3, 0, 0)
	EndSwitch
	Return $iubound
EndFunc

Func _arraydisplay(Const ByRef $avarray, $stitle = "Array: ListView Display", $iitemlimit = -1, $itranspose = 0, $sseparator = "", $sreplace = "|", $sheader = "")
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	Local $idimension = UBound($avarray, 0), $iubound = UBound($avarray, 1) - 1, $isubmax = UBound($avarray, 2) - 1
	If $idimension > 2 Then Return SetError(2, 0, 0)
	If $sseparator = "" Then $sseparator = Chr(124)
	If _arraysearch($avarray, $sseparator, 0, 0, 0, 1) <> -1 Then
		For $x = 1 To 255
			If $x >= 32 AND $x <= 127 Then ContinueLoop
			Local $sfind = _arraysearch($avarray, Chr($x), 0, 0, 0, 1)
			If $sfind = -1 Then
				$sseparator = Chr($x)
				ExitLoop
			EndIf
		Next
	EndIf
	Local $vtmp, $ibuffer = 4094
	Local $icollimit = 250
	Local $ioneventmode = Opt("GUIOnEventMode", 0), $sdataseparatorchar = Opt("GUIDataSeparatorChar", $sseparator)
	If $isubmax < 0 Then $isubmax = 0
	If $itranspose Then
		$vtmp = $iubound
		$iubound = $isubmax
		$isubmax = $vtmp
	EndIf
	If $isubmax > $icollimit Then $isubmax = $icollimit
	If $iitemlimit < 1 Then $iitemlimit = $iubound
	If $iubound > $iitemlimit Then $iubound = $iitemlimit
	If $sheader = "" Then
		$sheader = "Row  "
		For $i = 0 To $isubmax
			$sheader &= $sseparator & "Col " & $i
		Next
	EndIf
	Local $avarraytext[$iubound + 1]
	For $i = 0 To $iubound
		$avarraytext[$i] = "[" & $i & "]"
		For $j = 0 To $isubmax
			If $idimension = 1 Then
				If $itranspose Then
					$vtmp = $avarray[$j]
				Else
					$vtmp = $avarray[$i]
				EndIf
			Else
				If $itranspose Then
					$vtmp = $avarray[$j][$i]
				Else
					$vtmp = $avarray[$i][$j]
				EndIf
			EndIf
			$vtmp = StringReplace($vtmp, $sseparator, $sreplace, 0, 1)
			If StringLen($vtmp) > $ibuffer Then $vtmp = StringLeft($vtmp, $ibuffer)
			$avarraytext[$i] &= $sseparator & $vtmp
		Next
	Next
	Local Const $_arrayconstant_gui_dockborders = 102
	Local Const $_arrayconstant_gui_dockbottom = 64
	Local Const $_arrayconstant_gui_dockheight = 512
	Local Const $_arrayconstant_gui_dockleft = 2
	Local Const $_arrayconstant_gui_dockright = 4
	Local Const $_arrayconstant_gui_event_close = -3
	Local Const $_arrayconstant_lvm_getcolumnwidth = (4096 + 29)
	Local Const $_arrayconstant_lvm_getitemcount = (4096 + 4)
	Local Const $_arrayconstant_lvm_getitemstate = (4096 + 44)
	Local Const $_arrayconstant_lvm_setextendedlistviewstyle = (4096 + 54)
	Local Const $_arrayconstant_lvs_ex_fullrowselect = 32
	Local Const $_arrayconstant_lvs_ex_gridlines = 1
	Local Const $_arrayconstant_lvs_showselalways = 8
	Local Const $_arrayconstant_ws_ex_clientedge = 512
	Local Const $_arrayconstant_ws_maximizebox = 65536
	Local Const $_arrayconstant_ws_minimizebox = 131072
	Local Const $_arrayconstant_ws_sizebox = 262144
	Local $iwidth = 640, $iheight = 480
	Local $hgui = GUICreate($stitle, $iwidth, $iheight, Default, Default, BitOR($_arrayconstant_ws_sizebox, $_arrayconstant_ws_minimizebox, $_arrayconstant_ws_maximizebox))
	Local $aiguisize = WinGetClientSize($hgui)
	Local $hlistview = GUICtrlCreateListView($sheader, 0, 0, $aiguisize[0], $aiguisize[1] - 26, $_arrayconstant_lvs_showselalways)
	Local $hcopy = GUICtrlCreateButton("Copy Selected", 3, $aiguisize[1] - 23, $aiguisize[0] - 6, 20)
	GUICtrlSetResizing($hlistview, $_arrayconstant_gui_dockborders)
	GUICtrlSetResizing($hcopy, $_arrayconstant_gui_dockleft + $_arrayconstant_gui_dockright + $_arrayconstant_gui_dockbottom + $_arrayconstant_gui_dockheight)
	GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_setextendedlistviewstyle, $_arrayconstant_lvs_ex_gridlines, $_arrayconstant_lvs_ex_gridlines)
	GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_setextendedlistviewstyle, $_arrayconstant_lvs_ex_fullrowselect, $_arrayconstant_lvs_ex_fullrowselect)
	GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_setextendedlistviewstyle, $_arrayconstant_ws_ex_clientedge, $_arrayconstant_ws_ex_clientedge)
	For $i = 0 To $iubound
		GUICtrlCreateListViewItem($avarraytext[$i], $hlistview)
	Next
	$iwidth = 0
	For $i = 0 To $isubmax + 1
		$iwidth += GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_getcolumnwidth, $i, 0)
	Next
	If $iwidth < 250 Then $iwidth = 230
	$iwidth += 20
	If $iwidth > @DesktopWidth Then $iwidth = @DesktopWidth - 100
	WinMove($hgui, "", (@DesktopWidth - $iwidth) / 2, Default, $iwidth)
	GUISetState(@SW_SHOW, $hgui)
	While 1
		Switch GUIGetMsg()
			Case $_arrayconstant_gui_event_close
				ExitLoop
			Case $hcopy
				Local $sclip = ""
				Local $aicuritems[1] = [0]
				For $i = 0 To GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_getitemcount, 0, 0)
					If GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_getitemstate, $i, 2) Then
						$aicuritems[0] += 1
						ReDim $aicuritems[$aicuritems[0] + 1]
						$aicuritems[$aicuritems[0]] = $i
					EndIf
				Next
				If NOT $aicuritems[0] Then
					For $sitem In $avarraytext
						$sclip &= $sitem & @CRLF
					Next
				Else
					For $i = 1 To UBound($aicuritems) - 1
						$sclip &= $avarraytext[$aicuritems[$i]] & @CRLF
					Next
				EndIf
				ClipPut($sclip)
		EndSwitch
	WEnd
	GUIDelete($hgui)
	Opt("GUIOnEventMode", $ioneventmode)
	Opt("GUIDataSeparatorChar", $sdataseparatorchar)
	Return 1
EndFunc

Func _arrayfindall(Const ByRef $avarray, $vvalue, $istart = 0, $iend = 0, $icase = 0, $icompare = 0, $isubitem = 0)
	$istart = _arraysearch($avarray, $vvalue, $istart, $iend, $icase, $icompare, 1, $isubitem)
	If @error Then Return SetError(@error, 0, -1)
	Local $iindex = 0, $avresult[UBound($avarray)]
	Do
		$avresult[$iindex] = $istart
		$iindex += 1
		$istart = _arraysearch($avarray, $vvalue, $istart + 1, $iend, $icase, $icompare, 1, $isubitem)
	Until @error
	ReDim $avresult[$iindex]
	Return $avresult
EndFunc

Func _arrayinsert(ByRef $avarray, $ielement, $vvalue = "")
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, 0)
	Local $iubound = UBound($avarray) + 1
	ReDim $avarray[$iubound]
	For $i = $iubound - 1 To $ielement + 1 Step -1
		$avarray[$i] = $avarray[$i - 1]
	Next
	$avarray[$ielement] = $vvalue
	Return $iubound
EndFunc

Func _arraymax(Const ByRef $avarray, $icompnumeric = 0, $istart = 0, $iend = 0)
	Local $iresult = _arraymaxindex($avarray, $icompnumeric, $istart, $iend)
	If @error Then Return SetError(@error, 0, "")
	Return $avarray[$iresult]
EndFunc

Func _arraymaxindex(Const ByRef $avarray, $icompnumeric = 0, $istart = 0, $iend = 0)
	If NOT IsArray($avarray) OR UBound($avarray, 0) <> 1 Then Return SetError(1, 0, -1)
	If UBound($avarray, 0) <> 1 Then Return SetError(3, 0, -1)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(2, 0, -1)
	Local $imaxindex = $istart
	If $icompnumeric Then
		For $i = $istart To $iend
			If Number($avarray[$imaxindex]) < Number($avarray[$i]) Then $imaxindex = $i
		Next
	Else
		For $i = $istart To $iend
			If $avarray[$imaxindex] < $avarray[$i] Then $imaxindex = $i
		Next
	EndIf
	Return $imaxindex
EndFunc

Func _arraymin(Const ByRef $avarray, $icompnumeric = 0, $istart = 0, $iend = 0)
	Local $iresult = _arrayminindex($avarray, $icompnumeric, $istart, $iend)
	If @error Then Return SetError(@error, 0, "")
	Return $avarray[$iresult]
EndFunc

Func _arrayminindex(Const ByRef $avarray, $icompnumeric = 0, $istart = 0, $iend = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, -1)
	If UBound($avarray, 0) <> 1 Then Return SetError(3, 0, -1)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(2, 0, -1)
	Local $iminindex = $istart
	If $icompnumeric Then
		For $i = $istart To $iend
			If Number($avarray[$iminindex]) > Number($avarray[$i]) Then $iminindex = $i
		Next
	Else
		For $i = $istart To $iend
			If $avarray[$iminindex] > $avarray[$i] Then $iminindex = $i
		Next
	EndIf
	Return $iminindex
EndFunc

Func _arraypermute(ByRef $avarray, $sdelim = "")
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, 0)
	Local $isize = UBound($avarray), $ifactorial = 1, $aidx[$isize], $aresult[1], $icount = 1
	For $i = 0 To $isize - 1
		$aidx[$i] = $i
	Next
	For $i = $isize To 1 Step -1
		$ifactorial *= $i
	Next
	ReDim $aresult[$ifactorial + 1]
	$aresult[0] = $ifactorial
	__array_exeterinternal($avarray, 0, $isize, $sdelim, $aidx, $aresult, $icount)
	Return $aresult
EndFunc

Func _arraypop(ByRef $avarray)
	If (NOT IsArray($avarray)) Then Return SetError(1, 0, "")
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, "")
	Local $iubound = UBound($avarray) - 1, $slastval = $avarray[$iubound]
	If NOT $iubound Then
		$avarray = ""
	Else
		ReDim $avarray[$iubound]
	EndIf
	Return $slastval
EndFunc

Func _arraypush(ByRef $avarray, $vvalue, $idirection = 0)
	If (NOT IsArray($avarray)) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(3, 0, 0)
	Local $iubound = UBound($avarray) - 1
	If IsArray($vvalue) Then
		Local $iubounds = UBound($vvalue)
		If ($iubounds - 1) > $iubound Then Return SetError(2, 0, 0)
		If $idirection Then
			For $i = $iubound To $iubounds Step -1
				$avarray[$i] = $avarray[$i - $iubounds]
			Next
			For $i = 0 To $iubounds - 1
				$avarray[$i] = $vvalue[$i]
			Next
		Else
			For $i = 0 To $iubound - $iubounds
				$avarray[$i] = $avarray[$i + $iubounds]
			Next
			For $i = 0 To $iubounds - 1
				$avarray[$i + $iubound - $iubounds + 1] = $vvalue[$i]
			Next
		EndIf
	Else
		If $idirection Then
			For $i = $iubound To 1 Step -1
				$avarray[$i] = $avarray[$i - 1]
			Next
			$avarray[0] = $vvalue
		Else
			For $i = 0 To $iubound - 1
				$avarray[$i] = $avarray[$i + 1]
			Next
			$avarray[$iubound] = $vvalue
		EndIf
	EndIf
	Return 1
EndFunc

Func _arrayreverse(ByRef $avarray, $istart = 0, $iend = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(3, 0, 0)
	Local $vtmp, $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(2, 0, 0)
	For $i = $istart To Int(($istart + $iend - 1) / 2)
		$vtmp = $avarray[$i]
		$avarray[$i] = $avarray[$iend]
		$avarray[$iend] = $vtmp
		$iend -= 1
	Next
	Return 1
EndFunc

Func _arraysearch(Const ByRef $avarray, $vvalue, $istart = 0, $iend = 0, $icase = 0, $icompare = 0, $iforward = 1, $isubitem = -1)
	If NOT IsArray($avarray) Then Return SetError(1, 0, -1)
	If UBound($avarray, 0) > 2 OR UBound($avarray, 0) < 1 Then Return SetError(2, 0, -1)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(4, 0, -1)
	Local $istep = 1
	If NOT $iforward Then
		Local $itmp = $istart
		$istart = $iend
		$iend = $itmp
		$istep = -1
	EndIf
	Local $icomptype = False
	If $icompare = 2 Then
		$icompare = 0
		$icomptype = True
	EndIf
	Switch UBound($avarray, 0)
		Case 1
			If NOT $icompare Then
				If NOT $icase Then
					For $i = $istart To $iend Step $istep
						If $icomptype AND VarGetType($avarray[$i]) <> VarGetType($vvalue) Then ContinueLoop
						If $avarray[$i] = $vvalue Then Return $i
					Next
				Else
					For $i = $istart To $iend Step $istep
						If $icomptype AND VarGetType($avarray[$i]) <> VarGetType($vvalue) Then ContinueLoop
						If $avarray[$i] == $vvalue Then Return $i
					Next
				EndIf
			Else
				For $i = $istart To $iend Step $istep
					If StringInStr($avarray[$i], $vvalue, $icase) > 0 Then Return $i
				Next
			EndIf
		Case 2
			Local $iuboundsub = UBound($avarray, 2) - 1
			If $isubitem > $iuboundsub Then $isubitem = $iuboundsub
			If $isubitem < 0 Then
				$isubitem = 0
			Else
				$iuboundsub = $isubitem
			EndIf
			For $j = $isubitem To $iuboundsub
				If NOT $icompare Then
					If NOT $icase Then
						For $i = $istart To $iend Step $istep
							If $icomptype AND VarGetType($avarray[$i][$j]) <> VarGetType($vvalue) Then ContinueLoop
							If $avarray[$i][$j] = $vvalue Then Return $i
						Next
					Else
						For $i = $istart To $iend Step $istep
							If $icomptype AND VarGetType($avarray[$i][$j]) <> VarGetType($vvalue) Then ContinueLoop
							If $avarray[$i][$j] == $vvalue Then Return $i
						Next
					EndIf
				Else
					For $i = $istart To $iend Step $istep
						If StringInStr($avarray[$i][$j], $vvalue, $icase) > 0 Then Return $i
					Next
				EndIf
			Next
		Case Else
			Return SetError(7, 0, -1)
	EndSwitch
	Return SetError(6, 0, -1)
EndFunc

Func _arraysort(ByRef $avarray, $idescending = 0, $istart = 0, $iend = 0, $isubitem = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(2, 0, 0)
	Switch UBound($avarray, 0)
		Case 1
			__arrayquicksort1d($avarray, $istart, $iend)
			If $idescending Then _arrayreverse($avarray, $istart, $iend)
		Case 2
			Local $isubmax = UBound($avarray, 2) - 1
			If $isubitem > $isubmax Then Return SetError(3, 0, 0)
			If $idescending Then
				$idescending = -1
			Else
				$idescending = 1
			EndIf
			__arrayquicksort2d($avarray, $idescending, $istart, $iend, $isubitem, $isubmax)
		Case Else
			Return SetError(4, 0, 0)
	EndSwitch
	Return 1
EndFunc

Func __arrayquicksort1d(ByRef $avarray, ByRef $istart, ByRef $iend)
	If $iend <= $istart Then Return 
	Local $vtmp
	If ($iend - $istart) < 15 Then
		Local $vcur
		For $i = $istart + 1 To $iend
			$vtmp = $avarray[$i]
			If IsNumber($vtmp) Then
				For $j = $i - 1 To $istart Step -1
					$vcur = $avarray[$j]
					If ($vtmp >= $vcur AND IsNumber($vcur)) OR (NOT IsNumber($vcur) AND StringCompare($vtmp, $vcur) >= 0) Then ExitLoop
					$avarray[$j + 1] = $vcur
				Next
			Else
				For $j = $i - 1 To $istart Step -1
					If (StringCompare($vtmp, $avarray[$j]) >= 0) Then ExitLoop
					$avarray[$j + 1] = $avarray[$j]
				Next
			EndIf
			$avarray[$j + 1] = $vtmp
		Next
		Return 
	EndIf
	Local $l = $istart, $r = $iend, $vpivot = $avarray[Int(($istart + $iend) / 2)], $fnum = IsNumber($vpivot)
	Do
		If $fnum Then
			While ($avarray[$l] < $vpivot AND IsNumber($avarray[$l])) OR (NOT IsNumber($avarray[$l]) AND StringCompare($avarray[$l], $vpivot) < 0)
				$l += 1
			WEnd
			While ($avarray[$r] > $vpivot AND IsNumber($avarray[$r])) OR (NOT IsNumber($avarray[$r]) AND StringCompare($avarray[$r], $vpivot) > 0)
				$r -= 1
			WEnd
		Else
			While (StringCompare($avarray[$l], $vpivot) < 0)
				$l += 1
			WEnd
			While (StringCompare($avarray[$r], $vpivot) > 0)
				$r -= 1
			WEnd
		EndIf
		If $l <= $r Then
			$vtmp = $avarray[$l]
			$avarray[$l] = $avarray[$r]
			$avarray[$r] = $vtmp
			$l += 1
			$r -= 1
		EndIf
	Until $l > $r
	__arrayquicksort1d($avarray, $istart, $r)
	__arrayquicksort1d($avarray, $l, $iend)
EndFunc

Func __arrayquicksort2d(ByRef $avarray, ByRef $istep, ByRef $istart, ByRef $iend, ByRef $isubitem, ByRef $isubmax)
	If $iend <= $istart Then Return 
	Local $vtmp, $l = $istart, $r = $iend, $vpivot = $avarray[Int(($istart + $iend) / 2)][$isubitem], $fnum = IsNumber($vpivot)
	Do
		If $fnum Then
			While ($istep * ($avarray[$l][$isubitem] - $vpivot) < 0 AND IsNumber($avarray[$l][$isubitem])) OR (NOT IsNumber($avarray[$l][$isubitem]) AND $istep * StringCompare($avarray[$l][$isubitem], $vpivot) < 0)
				$l += 1
			WEnd
			While ($istep * ($avarray[$r][$isubitem] - $vpivot) > 0 AND IsNumber($avarray[$r][$isubitem])) OR (NOT IsNumber($avarray[$r][$isubitem]) AND $istep * StringCompare($avarray[$r][$isubitem], $vpivot) > 0)
				$r -= 1
			WEnd
		Else
			While ($istep * StringCompare($avarray[$l][$isubitem], $vpivot) < 0)
				$l += 1
			WEnd
			While ($istep * StringCompare($avarray[$r][$isubitem], $vpivot) > 0)
				$r -= 1
			WEnd
		EndIf
		If $l <= $r Then
			For $i = 0 To $isubmax
				$vtmp = $avarray[$l][$i]
				$avarray[$l][$i] = $avarray[$r][$i]
				$avarray[$r][$i] = $vtmp
			Next
			$l += 1
			$r -= 1
		EndIf
	Until $l > $r
	__arrayquicksort2d($avarray, $istep, $istart, $r, $isubitem, $isubmax)
	__arrayquicksort2d($avarray, $istep, $l, $iend, $isubitem, $isubmax)
EndFunc

Func _arrayswap(ByRef $vitem1, ByRef $vitem2)
	Local $vtmp = $vitem1
	$vitem1 = $vitem2
	$vitem2 = $vtmp
EndFunc

Func _arraytoclip(Const ByRef $avarray, $istart = 0, $iend = 0)
	Local $sresult = _arraytostring($avarray, @CR, $istart, $iend)
	If @error Then Return SetError(@error, 0, 0)
	Return ClipPut($sresult)
EndFunc

Func _arraytostring(Const ByRef $avarray, $sdelim = "|", $istart = 0, $iend = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, "")
	If UBound($avarray, 0) <> 1 Then Return SetError(3, 0, "")
	Local $sresult, $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(2, 0, "")
	For $i = $istart To $iend
		$sresult &= $avarray[$i] & $sdelim
	Next
	Return StringTrimRight($sresult, StringLen($sdelim))
EndFunc

Func _arraytrim(ByRef $avarray, $itrimnum, $idirection = 0, $istart = 0, $iend = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, 0)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(5, 0, 0)
	If $idirection Then
		For $i = $istart To $iend
			$avarray[$i] = StringTrimRight($avarray[$i], $itrimnum)
		Next
	Else
		For $i = $istart To $iend
			$avarray[$i] = StringTrimLeft($avarray[$i], $itrimnum)
		Next
	EndIf
	Return 1
EndFunc

Func _arrayunique($aarray, $idimension = 1, $ibase = 0, $icase = 0, $vdelim = "|")
	Local $iubounddim
	If $vdelim = "|" Then $vdelim = Chr(1)
	If NOT IsArray($aarray) Then Return SetError(1, 0, 0)
	If NOT $idimension > 0 Then
		Return SetError(3, 0, 0)
	Else
		$iubounddim = UBound($aarray, 1)
		If @error Then Return SetError(3, 0, 0)
		If $idimension > 1 Then
			Local $aarraytmp[1]
			For $i = 0 To $iubounddim - 1
				_arrayadd($aarraytmp, $aarray[$i][$idimension - 1])
			Next
			_arraydelete($aarraytmp, 0)
		Else
			If UBound($aarray, 0) = 1 Then
				Dim $aarraytmp[1]
				For $i = 0 To $iubounddim - 1
					_arrayadd($aarraytmp, $aarray[$i])
				Next
				_arraydelete($aarraytmp, 0)
			Else
				Dim $aarraytmp[1]
				For $i = 0 To $iubounddim - 1
					_arrayadd($aarraytmp, $aarray[$i][$idimension - 1])
				Next
				_arraydelete($aarraytmp, 0)
			EndIf
		EndIf
	EndIf
	Local $shold
	For $icc = $ibase To UBound($aarraytmp) - 1
		If NOT StringInStr($vdelim & $shold, $vdelim & $aarraytmp[$icc] & $vdelim, $icase) Then $shold &= $aarraytmp[$icc] & $vdelim
	Next
	If $shold Then
		$aarraytmp = StringSplit(StringTrimRight($shold, StringLen($vdelim)), $vdelim, 1)
		Return $aarraytmp
	EndIf
	Return SetError(2, 0, 0)
EndFunc

Func __array_exeterinternal(ByRef $avarray, $istart, $isize, $sdelim, ByRef $aidx, ByRef $aresult, ByRef $icount)
	If $istart == $isize - 1 Then
		For $i = 0 To $isize - 1
			$aresult[$icount] &= $avarray[$aidx[$i]] & $sdelim
		Next
		If $sdelim <> "" Then $aresult[$icount] = StringTrimRight($aresult[$icount], 1)
		$icount += 1
	Else
		Local $itemp
		For $i = $istart To $isize - 1
			$itemp = $aidx[$i]
			$aidx[$i] = $aidx[$istart]
			$aidx[$istart] = $itemp
			__array_exeterinternal($avarray, $istart + 1, $isize, $sdelim, $aidx, $aresult, $icount)
			$aidx[$istart] = $aidx[$i]
			$aidx[$i] = $itemp
		Next
	EndIf
EndFunc

Func __array_combinations($in, $ir)
	Local $i_total = 1
	For $i = $ir To 1 Step -1
		$i_total *= ($in / $i)
		$in -= 1
	Next
	Return Round($i_total)
EndFunc

Func __array_getnext($in, $ir, ByRef $ileft, $itotal, ByRef $aidx)
	If $ileft == $itotal Then
		$ileft -= 1
		Return 
	EndIf
	Local $i = $ir - 1
	While $aidx[$i] == $in - $ir + $i
		$i -= 1
	WEnd
	$aidx[$i] += 1
	For $j = $i + 1 To $ir - 1
		$aidx[$j] = $aidx[$i] + $j - $i
	Next
	$ileft -= 1
EndFunc

Global Const $fc_nooverwrite = 0
Global Const $fc_overwrite = 1
Global Const $ft_modified = 0
Global Const $ft_created = 1
Global Const $ft_accessed = 2
Global Const $fo_read = 0
Global Const $fo_append = 1
Global Const $fo_overwrite = 2
Global Const $fo_binary = 16
Global Const $fo_unicode = 32
Global Const $fo_utf16_le = 32
Global Const $fo_utf16_be = 64
Global Const $fo_utf8 = 128
Global Const $fo_utf8_nobom = 256
Global Const $eof = -1
Global Const $fd_filemustexist = 1
Global Const $fd_pathmustexist = 2
Global Const $fd_multiselect = 4
Global Const $fd_promptcreatenew = 8
Global Const $fd_promptoverwrite = 16
Global Const $create_new = 1
Global Const $create_always = 2
Global Const $open_existing = 3
Global Const $open_always = 4
Global Const $truncate_existing = 5
Global Const $invalid_set_file_pointer = -1
Global Const $file_begin = 0
Global Const $file_current = 1
Global Const $file_end = 2
Global Const $file_attribute_readonly = 1
Global Const $file_attribute_hidden = 2
Global Const $file_attribute_system = 4
Global Const $file_attribute_directory = 16
Global Const $file_attribute_archive = 32
Global Const $file_attribute_device = 64
Global Const $file_attribute_normal = 128
Global Const $file_attribute_temporary = 256
Global Const $file_attribute_sparse_file = 512
Global Const $file_attribute_reparse_point = 1024
Global Const $file_attribute_compressed = 2048
Global Const $file_attribute_offline = 4096
Global Const $file_attribute_not_content_indexed = 8192
Global Const $file_attribute_encrypted = 16384
Global Const $file_share_read = 1
Global Const $file_share_write = 2
Global Const $file_share_delete = 4
Global Const $generic_all = 268435456
Global Const $generic_execute = 536870912
Global Const $generic_write = 1073741824
Global Const $generic_read = -2147483648

Func _filecountlines($sfilepath)
	Local $hfile = FileOpen($sfilepath, $fo_read)
	If $hfile = -1 Then Return SetError(1, 0, 0)
	Local $sfilecontent = StringStripWS(FileRead($hfile), 2)
	FileClose($hfile)
	Local $atmp
	If StringInStr($sfilecontent, @LF) Then
		$atmp = StringSplit(StringStripCR($sfilecontent), @LF)
	ElseIf StringInStr($sfilecontent, @CR) Then
		$atmp = StringSplit($sfilecontent, @CR)
	Else
		If StringLen($sfilecontent) Then
			Return 1
		Else
			Return SetError(2, 0, 0)
		EndIf
	EndIf
	Return $atmp[0]
EndFunc

Func _filecreate($sfilepath)
	Local $hopenfile = FileOpen($sfilepath, $fo_overwrite)
	If $hopenfile = -1 Then Return SetError(1, 0, 0)
	Local $hwritefile = FileWrite($hopenfile, "")
	FileClose($hopenfile)
	If $hwritefile = -1 Then Return SetError(2, 0, 0)
	Return 1
EndFunc

Func _filelisttoarray($spath, $sfilter = "*", $iflag = 0)
	Local $hsearch, $sfile, $sfilelist, $sdelim = "|"
	$spath = StringRegExpReplace($spath, "[\\/]+\z", "") & "\"
	If NOT FileExists($spath) Then Return SetError(1, 1, "")
	If StringRegExp($sfilter, "[\\/:><\|]|(?s)\A\s*\z") Then Return SetError(2, 2, "")
	If NOT ($iflag = 0 OR $iflag = 1 OR $iflag = 2) Then Return SetError(3, 3, "")
	$hsearch = FileFindFirstFile($spath & $sfilter)
	If @error Then Return SetError(4, 4, "")
	While 1
		$sfile = FileFindNextFile($hsearch)
		If @error Then ExitLoop
		If ($iflag + @extended = 2) Then ContinueLoop
		$sfilelist &= $sdelim & $sfile
	WEnd
	FileClose($hsearch)
	If NOT $sfilelist Then Return SetError(4, 4, "")
	Return StringSplit(StringTrimLeft($sfilelist, 1), "|")
EndFunc

Func _fileprint($s_file, $i_show = @SW_HIDE)
	Local $a_ret = DllCall("shell32.dll", "int", "ShellExecuteW", "hwnd", 0, "wstr", "print", "wstr", $s_file, "wstr", "", "wstr", "", "int", $i_show)
	If @error Then Return SetError(@error, @extended, 0)
	If $a_ret[0] <= 32 Then Return SetError(10, $a_ret[0], 0)
	Return 1
EndFunc

Func _filereadtoarray($sfilepath, ByRef $aarray)
	Local $hfile = FileOpen($sfilepath, $fo_read)
	If $hfile = -1 Then Return SetError(1, 0, 0)
	Local $afile = FileRead($hfile, FileGetSize($sfilepath))
	If StringRight($afile, 1) = @LF Then $afile = StringTrimRight($afile, 1)
	If StringRight($afile, 1) = @CR Then $afile = StringTrimRight($afile, 1)
	FileClose($hfile)
	If StringInStr($afile, @LF) Then
		$aarray = StringSplit(StringStripCR($afile), @LF)
	ElseIf StringInStr($afile, @CR) Then
		$aarray = StringSplit($afile, @CR)
	Else
		If StringLen($afile) Then
			Dim $aarray[2] = [1, $afile]
		Else
			Return SetError(2, 0, 0)
		EndIf
	EndIf
	Return 1
EndFunc

Func _filewritefromarray($file, $a_array, $i_base = 0, $i_ubound = 0, $s_delim = "|")
	If NOT IsArray($a_array) Then Return SetError(2, 0, 0)
	Local $idims = UBound($a_array, 0)
	If $idims > 2 Then Return SetError(4, 0, 0)
	Local $last = UBound($a_array) - 1
	If $i_ubound < 1 OR $i_ubound > $last Then $i_ubound = $last
	If $i_base < 0 OR $i_base > $last Then $i_base = 0
	Local $hfile
	If IsString($file) Then
		$hfile = FileOpen($file, $fo_overwrite)
	Else
		$hfile = $file
	EndIf
	If $hfile = -1 Then Return SetError(1, 0, 0)
	Local $errorsav = 0
	Switch $idims
		Case 1
			For $x = $i_base To $i_ubound
				If FileWrite($hfile, $a_array[$x] & @CRLF) = 0 Then
					$errorsav = 3
					ExitLoop
				EndIf
			Next
		Case 2
			Local $s_temp
			For $x = $i_base To $i_ubound
				$s_temp = $a_array[$x][0]
				For $y = 1 To $idims
					$s_temp &= $s_delim & $a_array[$x][$y]
				Next
				If FileWrite($hfile, $s_temp & @CRLF) = 0 Then
					$errorsav = 3
					ExitLoop
				EndIf
			Next
	EndSwitch
	If IsString($file) Then FileClose($hfile)
	If $errorsav Then Return SetError($errorsav, 0, 0)
	Return 1
EndFunc

Func _filewritelog($slogpath, $slogmsg, $iflag = -1)
	Local $hopenfile = $slogpath, $iopenmode = $fo_append
	Local $sdatenow = @YEAR & "-" & @MON & "-" & @MDAY
	Local $stimenow = @HOUR & ":" & @MIN & ":" & @SEC
	Local $smsg = $sdatenow & " " & $stimenow & " : " & $slogmsg
	If $iflag <> -1 Then
		$smsg &= @CRLF & FileRead($slogpath)
		$iopenmode = $fo_overwrite
	EndIf
	If IsString($slogpath) Then
		$hopenfile = FileOpen($slogpath, $iopenmode)
		If $hopenfile = -1 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	Local $ireturn = FileWriteLine($hopenfile, $smsg)
	If IsString($slogpath) Then
		$ireturn = FileClose($hopenfile)
	EndIf
	If $ireturn <= 0 Then
		Return SetError(2, $ireturn, 0)
	EndIf
	Return $ireturn
EndFunc

Func _filewritetoline($sfile, $iline, $stext, $foverwrite = 0)
	If $iline <= 0 Then Return SetError(4, 0, 0)
	If NOT IsString($stext) Then
		$stext = String($stext)
		If $stext = "" Then Return SetError(6, 0, 0)
	EndIf
	If $foverwrite <> 0 AND $foverwrite <> 1 Then Return SetError(5, 0, 0)
	If NOT FileExists($sfile) Then Return SetError(2, 0, 0)
	Local $sread_file = FileRead($sfile)
	Local $asplit_file = StringSplit(StringStripCR($sread_file), @LF)
	If UBound($asplit_file) < $iline Then Return SetError(1, 0, 0)
	Local $iencoding = FileGetEncoding($sfile)
	Local $hfile = FileOpen($sfile, $iencoding + $fo_overwrite)
	If $hfile = -1 Then Return SetError(3, 0, 0)
	$sread_file = ""
	For $i = 1 To $asplit_file[0]
		If $i = $iline Then
			If $foverwrite = 1 Then
				If $stext <> "" Then $sread_file &= $stext & @CRLF
			Else
				$sread_file &= $stext & @CRLF & $asplit_file[$i] & @CRLF
			EndIf
		ElseIf $i < $asplit_file[0] Then
			$sread_file &= $asplit_file[$i] & @CRLF
		ElseIf $i = $asplit_file[0] Then
			$sread_file &= $asplit_file[$i]
		EndIf
	Next
	FileWrite($hfile, $sread_file)
	FileClose($hfile)
	Return 1
EndFunc

Func _pathfull($srelativepath, $sbasepath = @WorkingDir)
	If NOT $srelativepath OR $srelativepath = "." Then Return $sbasepath
	Local $sfullpath = StringReplace($srelativepath, "/", "\")
	Local Const $sfullpathconst = $sfullpath
	Local $spath
	Local $brootonly = StringLeft($sfullpath, 1) = "\" AND StringMid($sfullpath, 2, 1) <> "\"
	For $i = 1 To 2
		$spath = StringLeft($sfullpath, 2)
		If $spath = "\\" Then
			$sfullpath = StringTrimLeft($sfullpath, 2)
			Local $nserverlen = StringInStr($sfullpath, "\") - 1
			$spath = "\\" & StringLeft($sfullpath, $nserverlen)
			$sfullpath = StringTrimLeft($sfullpath, $nserverlen)
			ExitLoop
		ElseIf StringRight($spath, 1) = ":" Then
			$sfullpath = StringTrimLeft($sfullpath, 2)
			ExitLoop
		Else
			$sfullpath = $sbasepath & "\" & $sfullpath
		EndIf
	Next
	If $i = 3 Then Return ""
	If StringLeft($sfullpath, 1) <> "\" Then
		If StringLeft($sfullpathconst, 2) = StringLeft($sbasepath, 2) Then
			$sfullpath = $sbasepath & "\" & $sfullpath
		Else
			$sfullpath = "\" & $sfullpath
		EndIf
	EndIf
	Local $atemp = StringSplit($sfullpath, "\")
	Local $apathparts[$atemp[0]], $j = 0
	For $i = 2 To $atemp[0]
		If $atemp[$i] = ".." Then
			If $j Then $j -= 1
		ElseIf NOT ($atemp[$i] = "" AND $i <> $atemp[0]) AND $atemp[$i] <> "." Then
			$apathparts[$j] = $atemp[$i]
			$j += 1
		EndIf
	Next
	$sfullpath = $spath
	If NOT $brootonly Then
		For $i = 0 To $j - 1
			$sfullpath &= "\" & $apathparts[$i]
		Next
	Else
		$sfullpath &= $sfullpathconst
		If StringInStr($sfullpath, "..") Then $sfullpath = _pathfull($sfullpath)
	EndIf
	While StringInStr($sfullpath, ".\")
		$sfullpath = StringReplace($sfullpath, ".\", "\")
	WEnd
	Return $sfullpath
EndFunc

Func _pathgetrelative($sfrom, $sto)
	If StringRight($sfrom, 1) <> "\" Then $sfrom &= "\"
	If StringRight($sto, 1) <> "\" Then $sto &= "\"
	If $sfrom = $sto Then Return SetError(1, 0, StringTrimRight($sto, 1))
	Local $asfrom = StringSplit($sfrom, "\")
	Local $asto = StringSplit($sto, "\")
	If $asfrom[1] <> $asto[1] Then Return SetError(2, 0, StringTrimRight($sto, 1))
	Local $i = 2
	Local $idiff = 1
	While 1
		If $asfrom[$i] <> $asto[$i] Then
			$idiff = $i
			ExitLoop
		EndIf
		$i += 1
	WEnd
	$i = 1
	Local $srelpath = ""
	For $j = 1 To $asto[0]
		If $i >= $idiff Then
			$srelpath &= "\" & $asto[$i]
		EndIf
		$i += 1
	Next
	$srelpath = StringTrimLeft($srelpath, 1)
	$i = 1
	For $j = 1 To $asfrom[0]
		If $i > $idiff Then
			$srelpath = "..\" & $srelpath
		EndIf
		$i += 1
	Next
	If StringRight($srelpath, 1) == "\" Then $srelpath = StringTrimRight($srelpath, 1)
	Return $srelpath
EndFunc

Func _pathmake($szdrive, $szdir, $szfname, $szext)
	If StringLen($szdrive) Then
		If NOT (StringLeft($szdrive, 2) = "\\") Then $szdrive = StringLeft($szdrive, 1) & ":"
	EndIf
	If StringLen($szdir) Then
		If NOT (StringRight($szdir, 1) = "\") AND NOT (StringRight($szdir, 1) = "/") Then $szdir = $szdir & "\"
	EndIf
	If StringLen($szext) Then
		If NOT (StringLeft($szext, 1) = ".") Then $szext = "." & $szext
	EndIf
	Return $szdrive & $szdir & $szfname & $szext
EndFunc

Func _pathsplit($szpath, ByRef $szdrive, ByRef $szdir, ByRef $szfname, ByRef $szext)
	Local $drive = ""
	Local $dir = ""
	Local $fname = ""
	Local $ext = ""
	Local $pos
	Local $array[5]
	$array[0] = $szpath
	If StringMid($szpath, 2, 1) = ":" Then
		$drive = StringLeft($szpath, 2)
		$szpath = StringTrimLeft($szpath, 2)
	ElseIf StringLeft($szpath, 2) = "\\" Then
		$szpath = StringTrimLeft($szpath, 2)
		$pos = StringInStr($szpath, "\")
		If $pos = 0 Then $pos = StringInStr($szpath, "/")
		If $pos = 0 Then
			$drive = "\\" & $szpath
			$szpath = ""
		Else
			$drive = "\\" & StringLeft($szpath, $pos - 1)
			$szpath = StringTrimLeft($szpath, $pos - 1)
		EndIf
	EndIf
	Local $nposforward = StringInStr($szpath, "/", 0, -1)
	Local $nposbackward = StringInStr($szpath, "\", 0, -1)
	If $nposforward >= $nposbackward Then
		$pos = $nposforward
	Else
		$pos = $nposbackward
	EndIf
	$dir = StringLeft($szpath, $pos)
	$fname = StringRight($szpath, StringLen($szpath) - $pos)
	If StringLen($dir) = 0 Then $fname = $szpath
	$pos = StringInStr($fname, ".", 0, -1)
	If $pos Then
		$ext = StringRight($fname, StringLen($fname) - ($pos - 1))
		$fname = StringLeft($fname, $pos - 1)
	EndIf
	$szdrive = $drive
	$szdir = $dir
	$szfname = $fname
	$szext = $ext
	$array[1] = $drive
	$array[2] = $dir
	$array[3] = $fname
	$array[4] = $ext
	Return $array
EndFunc

Func _replacestringinfile($szfilename, $szsearchstring, $szreplacestring, $fcaseness = 0, $foccurance = 1)
	Local $iretval = 0
	Local $ncount, $sendswith
	If StringInStr(FileGetAttrib($szfilename), "R") Then Return SetError(6, 0, -1)
	Local $hfile = FileOpen($szfilename, $fo_read)
	If $hfile = -1 Then Return SetError(1, 0, -1)
	Local $s_totfile = FileRead($hfile, FileGetSize($szfilename))
	If StringRight($s_totfile, 2) = @CRLF Then
		$sendswith = @CRLF
	ElseIf StringRight($s_totfile, 1) = @CR Then
		$sendswith = @CR
	ElseIf StringRight($s_totfile, 1) = @LF Then
		$sendswith = @LF
	Else
		$sendswith = ""
	EndIf
	Local $afilelines = StringSplit(StringStripCR($s_totfile), @LF)
	FileClose($hfile)
	Local $iencoding = FileGetEncoding($szfilename)
	Local $hwritehandle = FileOpen($szfilename, $iencoding + $fo_overwrite)
	If $hwritehandle = -1 Then Return SetError(2, 0, -1)
	For $ncount = 1 To $afilelines[0]
		If StringInStr($afilelines[$ncount], $szsearchstring, $fcaseness) Then
			$afilelines[$ncount] = StringReplace($afilelines[$ncount], $szsearchstring, $szreplacestring, 1 - $foccurance, $fcaseness)
			$iretval = $iretval + 1
			If $foccurance = 0 Then
				$iretval = 1
				ExitLoop
			EndIf
		EndIf
	Next
	For $ncount = 1 To $afilelines[0] - 1
		If FileWriteLine($hwritehandle, $afilelines[$ncount]) = 0 Then
			FileClose($hwritehandle)
			Return SetError(3, 0, -1)
		EndIf
	Next
	If $afilelines[$ncount] <> "" Then FileWrite($hwritehandle, $afilelines[$ncount] & $sendswith)
	FileClose($hwritehandle)
	Return $iretval
EndFunc

Func _tempfile($s_directoryname = @TempDir, $s_fileprefix = "~", $s_fileextension = ".tmp", $i_randomlength = 7)
	If IsKeyword($s_fileprefix) Then $s_fileprefix = "~"
	If IsKeyword($s_fileextension) Then $s_fileextension = ".tmp"
	If IsKeyword($i_randomlength) Then $i_randomlength = 7
	If NOT FileExists($s_directoryname) Then $s_directoryname = @TempDir
	If NOT FileExists($s_directoryname) Then $s_directoryname = @ScriptDir
	If StringRight($s_directoryname, 1) <> "\" Then $s_directoryname = $s_directoryname & "\"
	Local $s_tempname
	Do
		$s_tempname = ""
		While StringLen($s_tempname) < $i_randomlength
			$s_tempname = $s_tempname & Chr(Random(97, 122, 1))
		WEnd
		$s_tempname = $s_directoryname & $s_fileprefix & $s_tempname & $s_fileextension
	Until NOT FileExists($s_tempname)
	Return $s_tempname
EndFunc

#NoTrayIcon
#EndRegion
