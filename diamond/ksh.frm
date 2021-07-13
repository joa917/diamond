VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5745
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   5745
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox List1 
      Height          =   1815
      Left            =   360
      TabIndex        =   3
      Top             =   840
      Width           =   1095
   End
   Begin VB.TextBox Text3 
      Height          =   615
      Left            =   2160
      TabIndex        =   2
      Text            =   "Text3"
      Top             =   2280
      Width           =   975
   End
   Begin VB.TextBox Text2 
      Height          =   615
      Left            =   2160
      TabIndex        =   1
      Text            =   "Text2"
      Top             =   1320
      Width           =   975
   End
   Begin VB.TextBox Text1 
      Height          =   615
      Left            =   2160
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   240
      Width           =   975
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim order As Integer


Private Sub Form_Load()
List1.AddItem ("kim1")
List1.AddItem ("kim2")
List1.AddItem ("kim3")
End Sub

Private Sub List1_Click()
Open "c:\kim\3-2.dat" For Input As #1
order = List1.ListIndex 'list
If order = 0 Then
Input #1, sex
Input #1, bir
Input #1, mark
Else: For i = 0 To order

Input #1, sex
Input #1, bir
Input #1, mark
Next i
End If
Close #1
Text1.Text = sex
Text2.Text = bir
Text3.Text = mark

End Sub
