unit uSellView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects, FMX.Edit,
  System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, uClientView,
  uProductView, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, Data.DB, Datasnap.DBClient, FMX.EditBox,
  FMX.NumberBox, uOrderController;

type
  TfrmSell = class(TForm)
    lyContainerClient: TLayout;
    lyHeader: TLayout;
    btnAddClient: TButton;
    lyFooter: TLayout;
    lyBody: TLayout;
    Layout1: TLayout;
    Layout2: TLayout;
    Rectangle1: TRectangle;
    lbClientName: TLabel;
    btnClose: TButton;
    btnConfirm: TButton;
    Image1: TImage;
    Layout3: TLayout;
    Rectangle2: TRectangle;
    btnSearchProd: TButton;
    Layout4: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lbVlrUni: TLabel;
    Rectangle3: TRectangle;
    Layout5: TLayout;
    Rectangle4: TRectangle;
    Label6: TLabel;
    lbVlTot: TLabel;
    GridViewOrder: TStringGrid;
    lbProductName: TLabel;
    CDOrder: TClientDataSet;
    CDOrdercodProd: TIntegerField;
    CDOrderqtd: TIntegerField;
    CDOrdervlTot: TCurrencyField;
    CDOrdervlUni: TCurrencyField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    CDOrderdescProd: TStringField;
    edtQtd: TNumberBox;
    edtCodProd: TNumberBox;
    edtVlrUni: TEdit;
    Label1: TLabel;
    btnFinish: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddClientClick(Sender: TObject);
    procedure btnSearchProdClick(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure edtQtdKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtCodProdKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure edtVlrUniKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edtCodProdExit(Sender: TObject);
    procedure edtVlrUniExit(Sender: TObject);
    procedure btnFinishClick(Sender: TObject);
  private
    { Private declarations }
    ForderController : TOrderController;
    FcodCliente: integer;
    FfrmClient : TfrmClient;
    FfrmProduct : TfrmProduct;
    FvlTot : Currency;
    Fediting : boolean;
    procedure ResetView;
    procedure OpenViewClient;
    procedure CloseViewClient;
    function ConfirmViewClient: boolean;
    procedure OpenViewProduct;
    procedure CloseViewProduct;
    function ConfirmViewProduct: boolean;
    procedure RefreshBtnTitle;
    procedure IncludOrder(aCodProd: integer; aNameProd: string;
      aVlUni:Currency; aQtd: integer);
    procedure EditOrder(aVlUni:Currency; aQtd: integer);
    procedure DelOrder;
    function GetProduct(aCodProd: integer): boolean;
    procedure Back;
    procedure GridViewOrderKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure EditViewOrder;
    procedure ChangeEditOrder(aEditing: boolean);
    function Validate: boolean;
  public
    { Public declarations }
  end;

var
  frmSell: TfrmSell;

implementation

{$R *.fmx}

uses uOrderView, uMenuView, uProductController;

procedure TfrmSell.Back;
begin
  TfrmMenu(Owner).FrameOpen(TfrmOrder);
end;

procedure TfrmSell.btnAddClientClick(Sender: TObject);
begin
  OpenViewClient;
end;

procedure TfrmSell.btnCloseClick(Sender: TObject);
begin
  if frmClient <> nil then
    CloseViewClient
  else if frmProduct <> nil then
    CloseViewProduct
  else if Fediting then
  begin
    ResetView;
    Fediting := False;
    ChangeEditOrder(false);
  end
  else if Owner is TfrmMenu then
    TfrmMenu(Owner).MsgInformation('','Tem certeza que deseja cancelar?',Back,nil);
end;

procedure TfrmSell.btnConfirmClick(Sender: TObject);
begin
  if frmClient <> nil then
  begin
    if ConfirmViewClient then
      CloseViewClient
    else
      TfrmMenu(Owner).MsgAlerta('Nenhum cliente selecionado!', nil);
  end else
  if frmProduct <> nil then
  begin
    if ConfirmViewProduct then
    begin
      CloseViewProduct;
      edtQtd.SetFocus;
    end else
      TfrmMenu(Owner).MsgAlerta('Nenhum Produto selecionado!', nil);
  end else
  begin
    if not Validate then
    begin
      TfrmMenu(Owner).MsgAlerta('Parâmetros Inválidos',nil);
      exit;
    end;
    if Fediting then
      EditOrder(
        StrToCurr(edtVlrUni.Text),
        StrToInt(edtQtd.Text)
      )
    else
      IncludOrder(
        StrToInt(edtCodProd.Text),
        lbProductName.Text,
        StrToCurr(EdtVlrUni.Text),
        StrToInt(edtQtd.Text)
      );
  end;
end;

procedure TfrmSell.btnFinishClick(Sender: TObject);
begin
  if CDOrder.IsEmpty then
  begin
    TfrmMenu(Owner).MsgAlerta('Incluia algum produto',nil);
  end else
  if FcodCliente = 0 then
  begin
    TfrmMenu(Owner).MsgAlerta('Selecione um cliente',nil);
  end else
  begin
    ForderController.SetOrder(FcodCliente, CDOrder, FvlTot);
    if ForderController.Commit then
    begin
      TfrmMenu(Owner).MsgSucesso('Sucesso ao incluir pedido',nil);
      CDOrder.EmptyDataSet;
      ResetView;
    end
    else
      TfrmMenu(Owner).MsgErro('Erro ao incluir pedido',nil);
  end;
end;

procedure TfrmSell.btnSearchProdClick(Sender: TObject);
begin
  OpenViewProduct;
end;

procedure TfrmSell.EditOrder(aVlUni: Currency; aQtd: integer);
var
  lOldVlrTot: Currency;
begin
  try
    lOldVlrTot := CDOrderqtd.AsInteger * CDOrdervlUni.AsCurrency;
    CDOrder.Edit;
    CDOrderqtd.AsInteger := aQtd;
    CDOrdervlUni.AsCurrency := aVlUni;
    CDOrdervlTot.AsCurrency := aVlUni * aQtd;
    CDOrder.Post;
    FvlTot := FvlTot + (aVlUni * aQtd) - lOldVlrTot;
    lbVlTot.Text := 'R$ '+FormatCurr('#.00',FvlTot);
    ResetView;
    edtCodProd.SetFocus; 
    Fediting := false;
    ChangeEditOrder(false); 
  except
    TfrmMenu(Owner).MsgErro('Problema ao editar pedido!',nil);
  end;  
end;

procedure TfrmSell.EditViewOrder;
begin
  Fediting := true;
  edtQtd.Text := CDOrderqtd.AsString;
  edtCodProd.Text := CDOrdercodProd.AsString;
  edtVlrUni.Text := FormatCurr('#.00', CDOrdervlUni.AsCurrency);
  lbVlrUni.Text := FormatCurr('#.00', CDOrdervlUni.AsCurrency);
  ChangeEditOrder(True);
end;

procedure TfrmSell.ChangeEditOrder(aEditing: boolean);
begin
  if aEditing then
  begin
    edtCodProd.Enabled := false;
    btnAddClient.Enabled := false;
    btnSearchProd.Enabled := false;
  end else
  begin
    edtCodProd.Enabled := true;
    btnAddClient.Enabled := true;
    btnSearchProd.Enabled := true;
  end;
  RefreshBtnTitle;
end;

procedure TfrmSell.CloseViewClient;
begin
  frmClient.DisposeOf;
  frmClient := nil;
  lyHeader.Visible := true;
  lyBody.Visible := true;
  Layout2.Enabled := true;
  RefreshBtnTitle;
end;

procedure TfrmSell.CloseViewProduct;
begin
  frmProduct.DisposeOf;
  frmProduct := nil;
  lyHeader.Visible := true;
  lyBody.Visible := true;
  Layout2.Enabled := true;
  RefreshBtnTitle;
end;

function TfrmSell.ConfirmViewClient : boolean;
begin
  if frmClient.CDClient.RecordCount <= 0 then
  begin
    result := false;
  end else
  begin
    FcodCliente := frmClient.CDClientcodigo.AsInteger;
    lbClientName.Text := frmClient.CDClientnome.AsString;
    btnAddClient.Text := 'Editar Cliente';
    btnAddClient.StyleLookup := 'BtnVOrangeStyle';
    result := true;
  end;
end;

function TfrmSell.ConfirmViewProduct : boolean;
begin
  if frmProduct.CDProdutos.RecordCount <= 0 then
  begin
    result := false;
  end else
  begin
    edtCodProd.Text := frmProduct.CDProdutoscodigo.AsString;
    lbProductName.Text := frmProduct.CDProdutosdescricao.AsString;
    lbVlrUni.Text := frmProduct.CDProdutospreco.AsString;
    result := true;
  end;
end;

procedure TfrmSell.DelOrder;
var
  lVlrTot: currency;
begin
  try
    lVlrTot := CDOrdervlTot.AsCurrency;
    CDOrder.Delete;
    FvlTot := FvlTot - lVlrTot;
    if FvlTot = 0.00 then
    begin
      lbVlTot.Text := 'R$ 0,00';
    end else
    begin
      lbVlTot.Text := 'R$ '+FormatCurr('#.00',FvlTot);
    end;
    
  except
    TfrmMenu(Owner).MsgErro('Problema ao excluir produto!',nil);
  end;
end;

procedure TfrmSell.edtCodProdExit(Sender: TObject);
begin
  if (StrToInt(edtCodProd.Text) <> 0) then
  begin
    GetProduct(StrToInt(edtCodProd.Text));
  end;
end;

procedure TfrmSell.edtCodProdKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = 13) then
  begin
    edtQtd.SetFocus;
  end;
end;

procedure TfrmSell.edtQtdKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if key = 13 then
  begin
    edtVlrUni.SetFocus;
  end;
end;

procedure TfrmSell.edtVlrUniExit(Sender: TObject);
begin
  try
    lbVlrUni.Text := FormatCurr('#.00',StrToCurr(edtVlrUni.Text));
  Except
    edtVlrUni.Text := lbVlrUni.Text;
  end;
end;

procedure TfrmSell.edtVlrUniKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    btnConfirm.SetFocus;
  end;
end;

procedure TfrmSell.FormCreate(Sender: TObject);
begin
  GridViewOrder.OnKeyDown := GridViewOrderKeyDown;
  CDOrder.CreateDataSet;
  ForderController := TOrderController.Create(self);
end;

function TfrmSell.GetProduct(aCodProd: integer): boolean;
var
  lProductController : TProductController;
begin
  lProductController := TProductController.Create(self);
  lProductController.Filter.Codigo := aCodProd;
  lProductController.Open;
  if lProductController.Count > 0 then
  begin
    lbProductName.Text := lProductController.GetProduct(0).GetDescricao;
    lbVlrUni.Text := FormatCurr('#.00',lProductController.GetProduct(0).GetPreco);
    edtVlrUni.Text := FormatCurr('#.00',lProductController.GetProduct(0).GetPreco);
    Result := True;
  end else
    Result := false;
end;

procedure TfrmSell.IncludOrder(aCodProd: integer; aNameProd: string;
  aVlUni: Currency; aQtd: integer);
begin
  try
    CDOrder.Insert;
    CDOrdercodProd.AsInteger := aCodProd;
    CDOrderdescProd.AsString := aNameProd;
    CDOrderqtd.AsInteger := aQtd;
    CDOrdervlUni.AsCurrency := aVlUni;
    CDOrdervlTot.AsCurrency := aVlUni * aQtd;
    CDOrder.Post;
    FvlTot := FvlTot + (aVlUni * aQtd);
    lbVlTot.Text := 'R$ '+FormatCurr('#.00',FvlTot);
    ResetView;
    edtCodProd.SetFocus;
  except
    TfrmMenu(Owner).MsgErro('Problema ao incluir pedido!',nil); 
  end;
end;

procedure TfrmSell.OpenViewClient;
begin
  frmClient := TfrmClient.Create(self);
  lyHeader.Visible := false;
  lyBody.Visible := false;
  Layout1.AddObject(TLayout(frmClient.FindComponent('lyContainerClient')));
  Layout2.Enabled := false;
  RefreshBtnTitle;
end;

procedure TfrmSell.OpenViewProduct;
begin
  frmProduct := TfrmProduct.Create(self);
  lyHeader.Visible := false;
  lyBody.Visible := false;
  Layout1.AddObject(TLayout(frmProduct.FindComponent('lyContainerClient')));
  Layout2.Enabled := false;
  RefreshBtnTitle;
end;

procedure TfrmSell.RefreshBtnTitle;
begin
  if (frmClient = nil) and (frmProduct = nil) and (Not Fediting) then
  begin
    btnClose.Text := 'Cancelar Venda';
    btnConfirm.Text := 'Incluir';
  end else
  begin
    btnClose.Text := 'Cancelar';
    btnConfirm.Text := 'Confirmar';
  end;
end;

procedure TfrmSell.ResetView;
begin
  edtCodProd.Text := '';
  edtQtd.Text := '';
  lbVlrUni.Text := '0,00';
  edtVlrUni.Text := '';
  lbProductName.Text := 'Selecione o Produto';
  Fediting := false;
  RefreshBtnTitle;
end;

function TfrmSell.Validate: boolean;
begin
  try
    if Fediting then
    begin
      if (StrToCurr(edtVlrUni.Text) > 0.00) and (StrToInt(edtQtd.Text) > 0) then
        result := true
      else
        result := false;   
    end else
    begin
      if (StrToInt(edtCodProd.Text) > 0) and ( StrToCurr(EdtVlrUni.Text) > 0.00) and (StrToInt(edtQtd.Text) > 0) then
        result := true
      else
        result := false
    end;
  except
    result := false;
  end;
end;

procedure TfrmSell.GridViewOrderKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if (Key = 13) and (not CDOrder.IsEmpty) then
    EditViewOrder
  else if (Key = 46) and (not CDOrder.IsEmpty) then
    TfrmMenu(Owner).MsgInformation('','Tem certeza que deseja apagar esse registro?',DelOrder,nil);
end;

end.
