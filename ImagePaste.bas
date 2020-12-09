B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.8
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private frm As Form
	Private ImageView1 As ImageView
	Private TextArea1 As TextArea
	Private SplitPane1 As SplitPane
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	frm.Initialize("frm", 600, 500)
	frm.RootPane.LoadLayout("ImagePaste")
	SplitPane1.LoadLayout("TextArea")
	SplitPane1.LoadLayout("ImageViewer")
End Sub

Public Sub ShowAndWait As String
	frm.ShowAndWait
	Return TextArea1.Text
End Sub

Sub PasteButton_MouseClicked (EventData As MouseEvent)
	Try
		Dim img As B4XBitmap=fx.Clipboard.GetImage
		ImageView1.SetImage(img)
		TextArea1.Text=Utils.Image2Base64(img)
	Catch
		Log(LastException)
		TextArea1.Text=""
	End Try
End Sub

Sub Button1_MouseClicked (EventData As MouseEvent)
	frm.Close
End Sub
