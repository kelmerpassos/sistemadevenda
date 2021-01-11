unit uMenuView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects,
  System.Generics.Collections,
  FMX.Effects, FMX.TabControl, FMX.ActnList,
  System.ImageList, FMX.ImgList, FMX.Ani, uUtilities;

type
  TfrmMenu = class(TForm)
    lyBack: TLayout;
    lyHeader: TLayout;
    recLogoEmpresa: TRectangle;
    recHeader: TRectangle;
    lbSubTituloPrincipal: TLabel;
    lyContainer: TLayout;
    pnMenu: TPanel;
    pnHeader: TPanel;
    imgUserLog: TImage;
    lbUserLog: TLabel;
    Line1: TLine;
    pnItens: TPanel;
    ShadowMenu: TShadowEffect;
    ImageList: TImageList;
    imgLogoEmpresa: TGlyph;
    btnOrder: TRectangle;
    Label3: TLabel;
    Image5: TImage;
    Label4: TLabel;
    Image6: TImage;
    btnExit: TRectangle;
    Label25: TLabel;
    Image9: TImage;
    btnClient: TRectangle;
    Label2: TLabel;
    Image4: TImage;
    btnProduct: TRectangle;
    ColorAnimation1: TColorAnimation;
    ColorAnimation2: TColorAnimation;
    ColorAnimation3: TColorAnimation;
    ColorAnimation4: TColorAnimation;
    procedure btnClientClick(Sender: TObject);
    procedure btnOrderClick(Sender: TObject);
    procedure btnProductClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
  private
    { Private declarations }
    FActiveFrame : TFrame;
    FMsgActive : boolean;
    //Seleciona titulo correspondente a tela aberta
    procedure WriteTitle(aFrame: TComponentClass);
    //Esconde lateral do menu, para tela de venda
    procedure FullMenu(aFrame: TComponentClass);
    //Fecha form
    procedure ExitForm;
  public
    { Public declarations }
    //Bloqueia form quando a mensagem estiver ativa
    procedure SetMsgActive(aMsgActive: boolean);
    //Abre o form de forma genetica
    procedure FrameOpen(aFrame: TComponentClass);
    //DIferente tipos de mensagens
    procedure MsgInformation(aTitulo:string;aMessage: string;aOk:TEvent=nil;aNao:TEvent=nil);
    procedure MsgErro(aMessage: string;aOk:TEvent);
    procedure MsgSucesso(aMessage: string;aOk:TEvent);
    procedure MsgAlerta(aMessage: string;aOk:TEvent);

  end;

var
  frmMenu: TfrmMenu;

implementation

{$R *.fmx}

uses uClientView, uOrderView, uProductView, uSellView, uMensage;


procedure TfrmMenu.btnClientClick(Sender: TObject);
begin
  FrameOpen(TfrmClient);
end;

procedure TfrmMenu.btnExitClick(Sender: TObject);
begin
  MsgInformation('', 'Tem certeza que deseja sair?', ExitForm, nil);
end;

procedure TfrmMenu.btnOrderClick(Sender: TObject);
begin
  FrameOpen(TfrmOrder);
end;

procedure TfrmMenu.btnProductClick(Sender: TObject);
begin
  FrameOpen(TfrmProduct);
end;

procedure TfrmMenu.ExitForm;
begin
  Self.Close;
end;

procedure TfrmMenu.FrameOpen(aFrame: TComponentClass);
var
  i : integer;
begin
  WriteTitle(aFrame);
  FullMenu(aFrame);
  if (FActiveFrame  = nil) or (Assigned(FActiveFrame) and
    (FActiveFrame.ClassName <> aFrame.ClassName)) then
  begin
    for I := lyContainer.ControlsCount -1 downto 0 do
    begin
      lyContainer.RemoveObject(lyContainer.Controls[i]);
    end;
    FActiveFrame.DisposeOf;
    FActiveFrame := nil;
    FActiveFrame := TFrame(aFrame.Create(self));
    lyContainer.AddObject(TLayout(FActiveFrame.FindComponent('lyContainerClient')));
  end;
end;

procedure TfrmMenu.FullMenu(aFrame: TComponentClass);
begin
  if aFrame = TfrmSell then
  begin
    pnMenu.Visible := false;
  end else
  begin
    pnMenu.Visible := true;
  end;
end;

procedure TfrmMenu.MsgAlerta(aMessage: string; aOk: TEvent);
var
  lMsgD : TfrmMensage;
begin
  if FMsgActive then
    exit;
  lMsgD := TfrmMensage.Create(self);
  lMsgD.Parent := self;
  lMsgD.ActionOk := aOk;
  lMsgD.init(tMsgDWarning,aMessage);
  SetMsgActive(True);
end;

procedure TfrmMenu.MsgErro(aMessage: string; aOk: TEvent);
var
  lMsgD : TfrmMensage;
begin
  if FMsgActive then
    exit;
  lMsgD := TfrmMensage.Create(self);
  lMsgD.Parent := self;
  lMsgD.ActionOk := aOk;
  lMsgD.init(tMsgDanger,aMessage);
  SetMsgActive(True);
end;

procedure TfrmMenu.MsgInformation(aTitulo, aMessage: string; aOk, aNao: TEvent);
var
  lMsgD : TfrmMensage;
begin
  if FMsgActive then
    exit;
  lMsgD := TfrmMensage.Create(self);
  lMsgD.Parent := self;
  lMsgD.ActionSim := aOk;
  lMsgD.ActionNao := aNao;
  lMsgD.init(tMsgDInformation,aMessage);
  SetMsgActive(True);
end;

procedure TfrmMenu.MsgSucesso(aMessage: string; aOk: TEvent);
var
  lMsgD : TfrmMensage;
begin
  if FMsgActive then
    exit;
  lMsgD := TfrmMensage.Create(self);
  lMsgD.Parent := self;
  lMsgD.ActionOk := aOk;
  lMsgD.init(tMsgDSuccess,aMessage);
  SetMsgActive(True);
end;

procedure TfrmMenu.SetMsgActive(aMsgActive: boolean);
begin
  FMsgActive := aMsgActive;
  lyContainer.Enabled := NOT aMsgActive;
end;

procedure TfrmMenu.WriteTitle(aFrame: TComponentClass);
begin
  if (aFrame =  TfrmOrder) then
  begin
    lbSubTituloPrincipal.Text := 'Pedidos';
  end else
  if aFrame = TfrmProduct then
  begin
    lbSubTituloPrincipal.Text := 'Produtos';
  end else
  if aFrame =  TfrmClient then
  begin
    lbSubTituloPrincipal.Text := 'Clientes';
  end else
  if aFrame = TfrmSell then
  begin
    lbSubTituloPrincipal.Text := 'Venda';
  end else
  begin
    lbSubTituloPrincipal.Text := 'Sistema de Vendas';
  end;
end;

initialization
  ReportMemoryLeaksOnShutdown := true;
end.
