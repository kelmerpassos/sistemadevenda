unit uMensage;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.ScrollBox, FMX.Memo, FMX.TabControl, FMX.Layouts,
  FMX.Controls.Presentation, FMX.Objects, FMX.ActnList, uUtilities;

type
  TfrmMensage = class(TFrame)
    RecBack: TRectangle;
    RecMensage: TRectangle;
    RecHeader: TRectangle;
    lbTitle: TLabel;
    lyBody: TLayout;
    ControlCustomBody: TTabControl;
    TabMsg1: TTabItem;
    RecFundoMsg1: TRectangle;
    lbText: TLabel;
    TabMsg2: TTabItem;
    RecFundoMsg2: TRectangle;
    MemoDetalhes: TMemo;
    ShadowEffect1: TShadowEffect;
    lyFooter: TLayout;
    ControlCustomFooter: TTabControl;
    TabFooter1: TTabItem;
    RecFundoFooter1: TRectangle;
    btnNao: TButton;
    btnSim: TButton;
    TabFooter2: TTabItem;
    RecFundoFooter2: TRectangle;
    BtnOk: TButton;
    procedure btnSimClick(Sender: TObject);
    procedure btnNaoClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
  private
    { Private declarations }
    FHeight : integer;
    FWidth : integer;

    procedure msgSuccess;
    procedure msgDanger;
    procedure msgInformation;
    procedure msgNone;
    procedure msgWarning;
  public
    { Public declarations }
    ActionSim: TEvent;
    ActionNao: TEvent;
    ActionOk: TEvent;
    procedure init(aTipo:TTypeMsg;aMsg:String;aTitulo:String='');
  end;

implementation

{$R *.fmx}

uses uMenuView;

{ TfrmMensagem }

procedure TfrmMensage.btnNaoClick(Sender: TObject);
begin
  TfrmMenu(Owner).SetMsgActive(False);
  if @ActionNao <> nil then
    ActionNao;
  Self.Free;
end;

procedure TfrmMensage.BtnOkClick(Sender: TObject);
begin
  TfrmMenu(Owner).SetMsgActive(False);
  if @ActionOk <> nil then
    ActionOk;
  Self.Free;
  Self := nil;
end;

procedure TfrmMensage.btnSimClick(Sender: TObject);
begin
  TfrmMenu(Owner).SetMsgActive(False);
  if @ActionSim <> nil then
    ActionSim;
  Self.Free;
end;

procedure TfrmMensage.init(aTipo:TTypeMsg;aMsg:String;aTitulo:String='');
begin
  FHeight := 200;
  if FHeight= 0 then
   RecMensage.Height   := (TForm(Owner).Height / 2) -100
  Else
   RecMensage.Height   := FHeight;

  if TForm(Owner).Width < 700 then
  begin
    RecMensage.Width   := TForm(Owner).Width - 50;
  end else
  begin
    RecMensage.Width   := 500;
  end;

  lbText.Text := aMsg;

  case aTipo of
    tMsgDNone: msgNone;
    tMsgDInformation: msgInformation;
    tMsgDWarning: msgWarning;
    tMsgDanger: msgDanger;
    tMsgDSuccess: msgSuccess;
  end;

  btnSim.Width := (RecMensage.Width/2)-50;
  btnNao.Width := (RecMensage.Width/2)-50;

  Self.BringToFront;
end;

procedure TfrmMensage.msgDanger;
begin
  lbTitle.TextSettings.HorzAlign := TTextAlign.Center;
  lbTitle.TextSettings.FontColor := $FFC1392B;
  lbTitle.Text := 'ERRO';
  ControlCustomFooter.ActiveTab := TabFooter2;
end;

procedure TfrmMensage.msgInformation;
begin
  lbTitle.TextSettings.HorzAlign := TTextAlign.Center;
  lbTitle.Text := 'INFORMAÇÃO';
  ControlCustomFooter.ActiveTab := TabFooter1;
end;

procedure TfrmMensage.msgNone;
begin

end;

procedure TfrmMensage.msgSuccess;
begin
  lbTitle.TextSettings.HorzAlign := TTextAlign.Center;
  lbTitle.TextSettings.FontColor := $FF27AE61;
  lbTitle.Text := 'SUCESSO';
  ControlCustomFooter.ActiveTab := TabFooter2;
end;

procedure TfrmMensage.msgWarning;
begin
  lbTitle.TextSettings.HorzAlign := TTextAlign.Center;
  lbTitle.TextSettings.FontColor := $FFF39C11;
  lbTitle.Text := 'ALERTA';
  ControlCustomFooter.ActiveTab := TabFooter2;
end;

end.
