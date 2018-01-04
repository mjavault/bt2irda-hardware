Sub RenumberPads

Dim Board
Dim Rpad
Dim PadNumber

Set Board = PCBServer.GetCurrentPCBBoard
If Board is Nothing Then Exit Sub
Pcbserver.PreProcess
Set PadObject = Board.GetObjectAtCursor(MkSet(ePadObject),_
AllLayers,"Select Pad To Start With")
PadNumber = PadObject.Name + 1

While Board.ChooseLocation(x,y, "Click Next Pad To Renumber") = True
  Set Rpad = Board.GetObjectAtXYAskUserIfAmbiguous(x,y,MkSet(_
  ePadObject),AllLayers,eEditAction_Change)

  If Not(Rpad is Nothing) Then
     Call PCBServer.SendMessageToRobots(Rpad.I_ObjectAddress,_
     c_Broadcast, PCBM_BeginModify, c_NoEventData)

     Rpad.Name = PadNumber

     Call PCBServer.SendMessageToRobots(Rpad.I_ObjectAddress,_
     c_Broadcast, PCBM_EndModify , c_NoEventData)
  End If

  PadNumber = PadNumber + 1
Wend

Pcbserver.PostProcess
ResetParameters
Call AddStringParameter("Action", "Redraw")
RunProcess("PCB:Zoom")

End Sub

