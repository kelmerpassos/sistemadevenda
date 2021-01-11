unit uOrderView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, FMX.Effects, FMX.Edit,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, Data.DB,
  Datasnap.DBClient, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, uOrderController;

type
  TfrmOrder = class(TForm)
    lyContainerClient: TLayout;
    lyHeader: TLayout;
    btnAdd: TButton;
    recSearch: TRectangle;
    edtSearch: TEdit;
    btnSearch: TButton;
    ShadowSearch: TShadowEffect;
    recOrderView: TRectangle;
    ShadowGrid: TShadowEffect;
    GridOrderView: TStringGrid;
    CDOrder: TClientDataSet;
    CDOrdernumero: TIntegerField;
    CDOrderdataEmissao: TDateField;
    CDOrdervlTot: TCurrencyField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    FOrderController : TOrderController;
    procedure Search(aText: string);
  end;

var
  frmOrder: TfrmOrder;

implementation

{$R *.fmx}

uses uMenuView, uSellView, uUtilities;

procedure TfrmOrder.btnAddClick(Sender: TObject);
begin
  if Owner is TfrmMenu then
    TfrmMenu(Owner).FrameOpen(TfrmSell);
end;

procedure TfrmOrder.btnSearchClick(Sender: TObject);
begin
  Search(Trim(edtSearch.Text));
end;

procedure TfrmOrder.edtSearchKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = 13 then
    Search(Trim(edtSearch.Text));
end;

procedure TfrmOrder.FormCreate(Sender: TObject);
begin
  CDOrder.CreateDataSet;
  FOrderController := TOrderController.Create(self);
end;

procedure TfrmOrder.Search(aText: string);
var
  I: Integer;
begin
  CDOrder.EmptyDataSet;
  FOrderController.Filter.Clear;
  if aText <> '' then
  begin
    if TGenericFunctions.IsNumeric(aText) then
      FOrderController.Filter.Numero := StrToInt(aText)
    else
      FOrderController.Filter.NomeCliente := aText;
  end;
  FOrderController.Open;
  for I := 0 to FOrderController.Count-1 do
  begin
    CDOrder.Insert;
    CDOrdernumero.AsInteger := FOrderController.GetOrder(I).GetNumPedido;
    CDOrdervlTot.AsCurrency := FOrderController.GetOrder(I).GetVlTot;
    CDOrderdataEmissao.AsDateTime := FOrderController.GetOrder(I).GetData;
    CDOrder.post;
  end;

end;

end.
