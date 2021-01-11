unit uClientView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, FMX.Effects, FMX.Edit,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, Data.DB,
  Datasnap.DBClient, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, uClientController;

type
  TfrmClient = class(TForm)
    lyContainerClient: TLayout;
    lyHeader: TLayout;
    recSearch: TRectangle;
    edtSearch: TEdit;
    btnSearch: TButton;
    ShadowSearch: TShadowEffect;
    recClientView: TRectangle;
    ShadowGrid: TShadowEffect;
    GridViewClient: TStringGrid;
    CDClient: TClientDataSet;
    CDClientcodigo: TIntegerField;
    CDClientnome: TStringField;
    CDClientcidade: TStringField;
    CDClientuf: TStringField;
    DataSource1: TDataSource;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    procedure btnSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
    FClientController : TClientController;
  public
    { Public declarations }
    procedure Search(aText: string);
  end;

var
  frmClient: TfrmClient;

implementation

{$R *.fmx}

uses uUtilities;

{ TfrmClient }

procedure TfrmClient.btnSearchClick(Sender: TObject);
begin
  Search(Trim(edtSearch.Text));
end;

procedure TfrmClient.edtSearchKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if key = 13 then
    Search(Trim(edtSearch.Text));
end;

procedure TfrmClient.FormCreate(Sender: TObject);
begin
  FClientController := TClientController.Create(self);
  CDClient.CreateDataSet;
end;

procedure TfrmClient.Search(aText: string);
var
  I: Integer;
begin
  CDClient.EmptyDataSet;
  FClientController.Filter.Clear;
  if aText <> '' then
  begin
    if TGenericFunctions.IsNumeric(aText) then
      FClientController.Filter.Codigo := StrToInt(aText)
    else
    begin
      FClientController.Filter.Nome := aText;
      FClientController.Filter.Cidade := aText;
      FClientController.Filter.Uf := aText;
    end;
  end;
  FClientController.Open;
  for I := 0 to FClientController.Count-1 do
  begin
    CDClient.Insert;
    CDClientcodigo.AsInteger := FClientController.GetProduct(I).GetCodigo;
    CDClientnome.AsString := FClientController.GetProduct(I).GetNome;
    CDClientcidade.AsString := FClientController.GetProduct(I).GetCidade;
    CDClientuf.AsString := FClientController.GetProduct(I).GetUf;
    CDClient.Post;
  end;
end;

end.
