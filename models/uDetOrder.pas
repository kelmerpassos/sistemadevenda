unit uDetOrder;

interface

uses System.Classes, uProduct, uOrder;

type
  TDetOrder = class(TComponent)
  private
    Fcodigo : Integer;
    Fqtd : Integer;
    FvlUni : Currency;
    FvlTot : Currency;
    Fproduto : TProduct;
    Fpedido : TOrder;
  public
    function SetCodigo(aCodigo: Integer): TDetOrder;
    function SetQtd(aQtd: Integer): TDetOrder;
    function SetVlUni(aVlUni: Currency): TDetOrder;
    function SetVlTot(aVlTot: Currency): TDetOrder;
    function GetCodigo: Integer;
    function GetQtd: Integer;
    function GetVlUni: Currency;
    function GetVlTot: Currency;
    function GetProduto: TProduct;
    function GetPedido: TOrder;
    constructor Create(aSender: TComponent); override;
    procedure Post;
  end;

implementation

{ TDetOrder }

uses uDM;

constructor TDetOrder.Create(aSender: TComponent);
begin
  inherited Create(aSender);
  Fpedido := TOrder.Create(self);
  Fproduto := TProduct.Create(self);
end;

function TDetOrder.GetCodigo: Integer;
begin
  Result := Fcodigo;
end;

function TDetOrder.GetPedido: TOrder;
begin
  Result := Fpedido;
end;

function TDetOrder.GetProduto: TProduct;
begin
  Result := Fproduto;
end;

function TDetOrder.GetQtd: Integer;
begin
  Result := Fqtd;
end;

function TDetOrder.GetVlTot: Currency;
begin
  Result := FvlTot;
end;

function TDetOrder.GetVlUni: Currency;
begin
  Result := FvlUni;
end;

procedure TDetOrder.Post;
begin
  DM.FDQuery.SQL.Clear;
  DM.FDQuery.SQL.Add('insert into ped_prod (num_pedido, cod_prod, qtd, vlTot, vlUni)');
  DM.FDQuery.SQL.Add('values (:NUM , :COD, :QTD, :VLTOT, :VLUNI)');
  DM.FDQuery.ParamByName('NUM').AsInteger := GetPedido.GetNumPedido;
  DM.FDQuery.ParamByName('COD').AsInteger := GetProduto.GetCodigo;
  DM.FDQuery.ParamByName('QTD').AsInteger := Fqtd;
  DM.FDQuery.ParamByName('VLTOT').AsCurrency := FvlTot;
  DM.FDQuery.ParamByName('VLUNI').AsCurrency := FvlUni;
  DM.FDQuery.ExecSQL;
end;

function TDetOrder.SetCodigo(aCodigo: Integer): TDetOrder;
begin
  Result := Self;
  Fcodigo := aCodigo;
end;

function TDetOrder.SetQtd(aQtd: Integer): TDetOrder;
begin
  Result := Self;
  Fqtd := aQtd;
end;

function TDetOrder.SetVlTot(aVlTot: Currency): TDetOrder;
begin
  Result := Self;
  FvlTot := aVlTot;
end;

function TDetOrder.SetVlUni(aVlUni: Currency): TDetOrder;
begin
  Result := Self;
  FvlUni := aVlUni;
end;

end.
