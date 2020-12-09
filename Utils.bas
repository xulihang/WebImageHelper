B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.8
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
End Sub

Sub Image2Base64(img As B4XBitmap) As String
	Dim imgPath As String=File.Combine(File.DirApp,"image.jpg")
	Dim out As OutputStream=File.OpenOutput(imgPath,"",False)
	img.WriteToStream(out,"100","JPEG")
	out.Close
	Dim su As StringUtils
	Return "data:image/jpeg;base64,"&su.EncodeBase64(File.ReadBytes(File.DirApp,"image.jpg"))
End Sub

Sub Base642Image(base64 As String) As Image
	If base64.StartsWith("data") Then
		base64=Regex.Replace("data.*?,",base64,"")
	End If
	Dim su As StringUtils
	File.WriteBytes(File.DirTemp,"temp.jpg",su.DecodeBase64(base64))
	Return fx.LoadImage(File.DirTemp,"temp.jpg")
End Sub

Sub DownloadImage(link As String) As ResumableSub
	If link.StartsWith("data") Then
		Try
			Dim img As Image=Base642Image(link)
			Return img
		Catch
			Log(LastException)
			Return "error"
		End Try
	End If
		
	Dim job As HttpJob
	job.Initialize("job",Me)
	job.Download(link)
	wait for (job) jobDone(job As HttpJob)
	If job.Success Then
		Return job.GetBitmap
	Else
		Log(job.ErrorMessage)
	End If
	Return "error"
End Sub

Sub DirectDownload(link As String,dir As String) As ResumableSub
	If link.StartsWith("data") Then
		Try
			Dim su As StringUtils
			Dim timestamp As String=DateTime.Now
			Dim filename As String=timestamp&".jpg"
			File.WriteBytes(dir,filename,su.DecodeBase64(link))
		Catch
			Log(LastException)
			Return "error"
		End Try
	End If
	
	Dim job As HttpJob
	job.Initialize("job",Me)
	job.Download(link)
	wait for (job) jobDone(job As HttpJob)
	If job.Success Then
		Dim timestamp As String=DateTime.Now
		Dim filename As String=timestamp&".jpg"
		'Dim headers As Map=job.Response.GetHeaders
		'If headers.ContainsKey("Content-Disposition") Then
		'	filename=headers.Get("Content-Disposition")
		'End If
		Log(filename)
		Dim out As OutputStream = File.OpenOutput(dir, filename, False)
		File.Copy2(job.GetInputStream, out)
		out.Close '<------ very important
	Else
		Log(job.ErrorMessage)
	End If
	Return "error"
End Sub