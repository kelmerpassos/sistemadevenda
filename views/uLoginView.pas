unit uLoginView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.Edit, FMX.Objects, FMX.Layouts;

type
  TfrmLogin = class(TForm)
    lyContainer: TLayout;
    ImageLogo: TImage;
    recLogin: TRectangle;
    ShadowEffect: TShadowEffect;
    btnLogin: TButton;
    StyleBookPrincipal: TStyleBook;
    ImageBack: TImage;
    procedure btnLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OpenMainForm;
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

uses uMenuView;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
  OpenMainForm;
end;

procedure TfrmLogin.OpenMainForm;
begin
  frmMenu := TfrmMenu.Create(self);
  frmMenu.Parent := self;
  frmMenu.StyleBook := self.StyleBook;
  frmMenu.ShowModal;
  frmLogin.Close;
  frmLogin.FreeOnRelease;
end;

end.
