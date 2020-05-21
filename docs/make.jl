using Documenter, FlippingPreprocess

makedocs(;
    modules=[FlippingPreprocess],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/DarioSarra/FlippingPreprocess.jl/blob/{commit}{path}#L{line}",
    sitename="FlippingPreprocess.jl",
    authors="DarioSarra",
    assets=String[],
)

deploydocs(;
    repo="github.com/DarioSarra/FlippingPreprocess.jl",
)
