WITH RankedRows AS (

    SELECT 'AGEO' AS Empresa,
        F.Fantasia AS Filial,
        A.Solicitacao,
        A.DtEmissao,
        A.Usuario AS UsuarioA,
        A.Observ,
        A.SitReg,
        B.DescrMater,
		E.CodTipoMater,
		E.DescrTipoMater,
        B.MotivoSol,
        B.DtOperAprov,
        C.RegCotacao,
        C.DtEmissao AS DtEmissaoC,
        C.Usuario AS UsuarioC,
        A.DtOperCan,
        A.OperCan,
        ROW_NUMBER() OVER(PARTITION BY A.RegSolicitacao ORDER BY A.DtEmissao) AS RowNumber
    FROM CorporateAgeo.dbo.SolicitacaoCompra A 
        LEFT JOIN CorporateAgeo.dbo.SolicitacaoCompraItem B (NOLOCK) ON B.RegSolicitacao = A.RegSolicitacao
        LEFT JOIN CorporateAgeo.dbo.CotacaoCompra C (NOLOCK) ON C.RegLicitacao = B.RegLicitacao
		LEFT JOIN CorporateAgeo.dbo.Materiais D (NOLOCK) ON D.Material = B.Material
		LEFT JOIN CorporateAgeo.dbo.TipoDeMaterial E (NOLOCK) ON E.CodTipoMater = D.CodTipoMater
		LEFT JOIN CorporateAgeo.dbo.Filial F (NOLOCK) ON F.Filial = A.Filial
    WHERE A.DtEmissao > '2024-01-01 00:00:00' AND A.SitReg = 'L'

)

SELECT Empresa, Filial, Solicitacao, DtEmissao, UsuarioA, Observ, SitReg, DescrMater, CodTipoMater, DescrTipoMater, MotivoSol, DtOperAprov, RegCotacao, DtEmissaoC, UsuarioC, DtOperCan, OperCan

FROM RankedRows

WHERE RowNumber = 1;
