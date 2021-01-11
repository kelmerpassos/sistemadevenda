program SellProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  uLoginView in 'views\uLoginView.pas' {frmLogin},
  uClient in 'models\uClient.pas',
  uOrder in 'models\uOrder.pas',
  uProduct in 'models\uProduct.pas',
  uDetOrder in 'models\uDetOrder.pas',
  uOrderController in 'controllers\uOrderController.pas',
  uProductController in 'controllers\uProductController.pas',
  uDetOrderController in 'controllers\uDetOrderController.pas',
  uClientController in 'controllers\uClientController.pas',
  uMenuView in 'views\uMenuView.pas' {frmMenu},
  uSellView in 'views\uSellView.pas' {frmSell},
  uProductView in 'views\uProductView.pas' {frmProduct},
  uOrderView in 'views\uOrderView.pas' {frmOrder},
  uClientView in 'views\uClientView.pas' {frmClient},
  uDM in 'models\uDM.pas' {DM: TDataModule},
  uUtilities in 'generics\uUtilities.pas',
  uMensage in 'generics\uMensage.pas' {frmMensage: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
