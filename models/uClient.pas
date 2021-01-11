unit uClient;

interface

uses System.Classes;

type
  TClientBase = class(TComponent)
    type
      TFilterClient = class
      private
        FUf: string;
        FCodigo: integer;
        FNome: string;
        FCidade: string;
        procedure SetCidade(const Value: string);
        procedure SetCodigo(const Value: integer);
        procedure SetNome(const Value: string);
        procedure SetUf(const Value: string);
      published
        property Nome : string read FNome write SetNome;
        property Cidade : string read FCidade write SetCidade;
        property Uf : string read FUf write SetUf;
        property Codigo : integer read FCodigo write SetCodigo;
      public
        procedure Clear;
      end;
  private
    FFilter: TFilterClient;
    procedure SetFilter(const Value: TFilterClient);
  published
    property Filter : TFilterClient read FFilter write SetFilter;
  end;

  TClient = class(TClientBase)
  private
    Fcodigo : Integer;
    Fnome: String;
    Fcidade: String;
    Fuf: String;
  public
    function SetCodigo(aCodigo: Integer): TClient;
    function SetNome(aNome: String): TClient;
    function SetCidade(aCidade: String): TClient;
    function SetUf(aUf: String): TClient;
    function GetCodigo: Integer;
    function GetNome: String;
    function GetCidade: String;
    function GetUf: String;
    function Get: TList;
  end;

implementation

uses FireDAC.Comp.Client, FireDAC.Dapt, uDM, System.SysUtils;

{ TClient }

function TClient.Get: TList;
var
  lQuery: TFDQuery;
  lBegin: boolean;
  lList : TList;
  lClient : TClient;
begin
  lBegin := True;
  lQuery := TFDQuery.Create(self);
  lQuery.Connection := DM.FDConnection;
  lQuery.Close;
  lQuery.SQL.add('SELECT codigo, nome, cidade, uf FROM clientes');
  //Identifica se é para trazer todos os registros
  if (Filter.Codigo <> 0) or (Filter.Nome <> '') then
  begin
    lQuery.SQL.add('WHERE');
    if Filter.Codigo <> 0 then
    begin
      lQuery.SQL.add('codigo = '+IntToStr(Filter.Codigo));
      lBegin := False;
    end;
    if Filter.Nome <> '' then
    begin
      {Junto com as condicionais não encadeadas, possibilitam utilizar vários
      filtros ao mesmo tempo, caso necessario}
      if NOT lBegin then lQuery.SQL.add('OR');
      lQuery.SQL.add('UPPER(nome) like '+QuotedStr('%'+UpperCase(Filter.Nome)+'%'));
      lBegin := False;
    end;
    if Filter.Cidade <> '' then
    begin
      if NOT lBegin then lQuery.SQL.add('OR');
      lQuery.SQL.add('UPPER(cidade) like '+QuotedStr('%'+UpperCase(Filter.Cidade)+'%'));
      lBegin := False;
    end;
    if Filter.FUf <> '' then
    begin
      if NOT lBegin then lQuery.SQL.add('OR');
      lQuery.SQL.add('UPPER(uf) = '+QuotedStr(UpperCase(Filter.Uf)));
    end;
  end;
  lQuery.Open();
  if lQuery.RecordCount > 0 then
  begin
    lList := TList.Create;
    while not lQuery.Eof do
    begin
      lClient := TClient.Create(self);
      lClient.Fcodigo := lQuery.FieldByName('codigo').AsInteger;
      lClient.Fnome := lQuery.FieldByName('nome').AsString;
      lClient.Fcidade := lQuery.FieldByName('cidade').AsString;
      lClient.Fuf := lQuery.FieldByName('uf').AsString;
      lList.Add(lClient);
      lQuery.Next;
    end;
    Result := lList;
  end else
  begin
    Result := nil;
  end;
end;

function TClient.GetCidade: String;
begin
  Result := Fcidade;
end;

function TClient.GetCodigo: Integer;
begin
  Result := Fcodigo;
end;

function TClient.GetNome: String;
begin
  Result := Fnome;
end;

function TClient.GetUf: String;
begin
  Result := Fuf;
end;

function TClient.SetCidade(aCidade: String): TClient;
begin
  Result := Self;
  Fcidade := aCidade;
end;

function TClient.SetCodigo(aCodigo: Integer): TClient;
begin
  Result := Self;
  Fcodigo := aCodigo;
end;

function TClient.SetNome(aNome: String): TClient;
begin
  Result := Self;
  Fnome := aNome;
end;

function TClient.SetUf(aUf: String): TClient;
begin
  Result := Self;
  Fuf := aUf;
end;

{ TClientBase.TFilterClient }

procedure TClientBase.TFilterClient.Clear;
begin
  FUf := '';
  FCodigo := 0;
  FNome := '';
  FCidade := '';
end;

procedure TClientBase.TFilterClient.SetCidade(const Value: string);
begin
  FCidade := Value;
end;

procedure TClientBase.TFilterClient.SetCodigo(const Value: integer);
begin
  FCodigo := Value;
end;

procedure TClientBase.TFilterClient.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TClientBase.TFilterClient.SetUf(const Value: string);
begin
  FUf := Value;
end;

{ TClientBase }

procedure TClientBase.SetFilter(const Value: TFilterClient);
begin
  FFilter := Value;
end;

end.
