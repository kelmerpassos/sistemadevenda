unit uProductView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, FMX.Effects, FMX.Edit,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, uProductController,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  Data.DB, Datasnap.DBClient;

type
  TfrmProduct = class(TForm)
    lyContainerClient: TLayout;
    lyHeader: TLayout;
    recSearch: TRectangle;
    edtSearch: TEdit;
    btnSearch: TButton;
    ShadowSearch: TShadowEffect;
    recProductView: TRectangle;
    ShadowGrid: TShadowEffect;
    GridProductView: TStringGrid;
    CDProdutos: TClientDataSet;
    CDProdutosdescricao: TStringField;
    CDProdutospreco: TCurrencyField;
    CDProdutoscodigo: TIntegerField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
    FProductController : TProductController;
  public
    { Public declarations }
    procedure Search(aText: string);
  end;

var
  frmProduct: TfrmProduct;

implementation

{$R *.fmx}

uses uUtilities;


procedure TfrmProduct.btnSearchClick(Sender: TObject);
begin
  Search(Trim(edtSearch.Text));
end;

procedure TfrmProduct.edtSearchKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = 13 then
    Search(Trim(edtSearch.Text));
end;

procedure TfrmProduct.FormCreate(Sender: TObject);
begin
  FProductController := TProductController.Create(self);
  CDProdutos.CreateDataSet;
end;

procedure TfrmProduct.Search(aText: string);
var
  I: Integer;
begin
  CDProdutos.EmptyDataSet;
  FProductController.Filter.Clear;
  if aText <> '' then
  begin
    if TGenericFunctions.IsNumeric(aText) then
      FProductController.Filter.Codigo := StrToInt(aText)
    else
      FProductController.Filter.Descricao := aText;
  end;
  FProductController.Open;
  for I := 0 to FProductController.Count-1 do
  begin
    CDProdutos.Insert;
    CDProdutoscodigo.AsInteger := FProductController.GetProduct(I).GetCodigo;
    CDProdutosdescricao.AsString := FProductController.GetProduct(I).GetDescricao;
    CDProdutospreco.AsCurrency := FProductController.GetProduct(I).GetPreco;
    CDProdutos.post;
  end;
end;

end.
