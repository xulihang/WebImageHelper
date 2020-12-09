B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.8
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private ImageView1 As ImageView
	Private ListView1 As ListView
	Private frm As Form
	Private Downloaded As Map
	Private TextArea1 As TextArea
	Private SplitPane1 As SplitPane
	Private SavePathTextField As TextField
	Private ProgressIndicator1 As ProgressIndicator

End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	frm.Initialize("frm", 400, 600)
	frm.RootPane.LoadLayout("ImageDownloader")
	SplitPane1.LoadLayout("ImageLinks")
	SplitPane1.LoadLayout("ImageViewer")
	Downloaded.Initialize
	SavePathTextField.Text=File.DirApp
End Sub

Public Sub SetList(srcs As List)
	ListView1.Items.Clear
	ListView1.Items.AddAll(srcs)
End Sub

Public Sub Show
	frm.Show
End Sub

Sub ListView1_SelectedIndexChanged(Index As Int)
	Dim src As String=ListView1.Items.Get(Index)
	If src<>"" Then
		If Downloaded.ContainsKey(src) Then
			ImageView1.SetImage(Downloaded.Get(src))
			fx.Clipboard.SetImage(ImageView1.GetImage)
		Else
			wait for (Utils.DownloadImage(src)) Complete (img As Image)
			Downloaded.Put(src,img)
			ImageView1.SetImage(img)
			fx.Clipboard.SetImage(img)
		End If
	End If
End Sub

Sub AppendButton_MouseClicked (EventData As MouseEvent)
	For Each link As String In Regex.Split(CRLF,TextArea1.Text)
		ListView1.Items.Add(link)
	Next
End Sub

Sub DownloadSelectedButton_MouseClicked (EventData As MouseEvent)
	ProgressIndicator1.Progress=0
	Dim src As String=ListView1.Items.Get(ListView1.SelectedIndex)
	If src<>"" Then
		wait for (Utils.DirectDownload(src,SavePathTextField.Text)) Complete (result As Object)
	End If
	ProgressIndicator1.Progress=1
End Sub

Sub DownloadAllButton_MouseClicked (EventData As MouseEvent)
	ProgressIndicator1.Progress=0
	Dim size As Int=ListView1.Items.Size
	Dim index As Int
	For Each src As String In ListView1.Items
		index=index+1
		wait for (Utils.DirectDownload(src,SavePathTextField.Text)) Complete (result As Object)
		ProgressIndicator1.Progress=index/size
	Next
	ProgressIndicator1.Progress=1
End Sub

Sub ListView1_Action
	If ListView1.SelectedIndex<>-1 Then
		Dim mi As MenuItem=Sender
		Select mi.Text
			Case "Replace"
				Dim ip As ImagePaste
				ip.Initialize
				Dim base64 As String=ip.ShowAndWait
				Dim src As String=ListView1.Items.Get(ListView1.SelectedIndex)
				Main.ReplaceImage(src,base64)
		End Select
	End If
End Sub
