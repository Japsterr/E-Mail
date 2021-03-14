unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, StdCtrls, IdIOHandler, IdIOHandlerSocket, idIOHandlerStack, IdSSL,
  idSSLOpenSSL, IdMessage, IdBaseComponent, IdComponent, IdTCPConnection,
  idTCPClient, idSMTP, idExplicitTLSClientServerbase, IdMessageClient, IdSMTPBase,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    btnSend: TButton;
    Memo1: TMemo;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    IdSMTP1: TIdSMTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdMessage1: TIdMessage;
    btnExit: TButton;
    Label5: TLabel;
    mBody: TMemo;
    edtSubject: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure IdSMTP1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure IdSSLIOHandlerSocketOpenSSL1Status(ASender: TObject;
      const AStatus: TIdStatus; const AStatusText: string);
    procedure IdSSLIOHandlerSocketOpenSSL1StatusInfo(const AMsg: string);
    procedure btnSendClick(Sender: TObject);
    procedure IdSMTP1TLSNotAvailable(Asender: TObject; var VContinue: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
  private

  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  IdAttachmentFile;

{$R *.dfm}

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  IdSMTP1.Disconnect;
  frmMain.Close;
  frmMain.Free;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  Memo1.Lines.Add('Just before connections starts');
  IdSMTP1.Connect;
  Memo1.Lines.Add('Connection completed');
  btnSend.Visible := True;
  btnExit.Visible := True;
  FocusControl(EdtSubject);
end;

procedure TfrmMain.btnSendClick(Sender: TObject);
begin
  Memo1.Clear;
  IdSMTP1.Username := Edit1.Text;
  IdSMTP1.Password := Edit2.Text;
  IdMessage1.FromList.EMailAddresses := Edit3.Text;
  IdMessage1.Recipients.EMailAddresses := Edit4.Text;
  IdMessage1.Subject := edtSubject.Text;
  IdMessage1.Body := mBody.Lines;
  Memo1.Lines.Add('Before send ...');
//  IdSMTP1.SendMsg(IdMessage1, False);  // die command het nie gewerk nie
  IdSMTP1.Send(IdMessage1);
  Memo1.Lines.Add('After send!!!');
  mBody.Clear;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Memo1.Clear;
  btnSend.Visible := False;
  btnExit.Visible := False;
end;

procedure TfrmMain.IdSMTP1Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  Memo1.Lines.Add('SMTP: ' + AStatusText);
end;

procedure TfrmMain.IdSMTP1TLSNotAvailable(Asender: TObject;
  var VContinue: Boolean);
begin
  Memo1.Lines.Add('SMTP: TLS Not available');
end;

procedure TfrmMain.IdSSLIOHandlerSocketOpenSSL1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: string);
begin
  Memo1.Lines.Add('SSLS: ' + AStatusText);
end;

procedure TfrmMain.IdSSLIOHandlerSocketOpenSSL1StatusInfo(const AMsg: string);
begin
  Memo1.Lines.Add('SSLI: ' + AMsg);
end;

end.
