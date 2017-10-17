path = "D:/data/InitialTrainingSet_rev1/"
files = path .* readdir("D:/data/InitialTrainingSet_rev1/") .* "/ASDI/asdifpwaypoint.csv"

@time addprocs()
using JuliaDB #43 seconds
@time @everywhere using Dagger, IndexedTables, JuliaDB # 0.5 second
@time df = JuliaDB.loadfiles(files, indexcols = ["asdiflightplanid", "ordinal"]);
@time JuliaDB.save(df,"d:/gcflights2");
@time df = JuliaDB.load("d:/gcflights2");

@everywhere function hello1(x)
   @NT(
       long = max(x.longitude),
       lat = max(x.latitude)
   )
end

@time df2 = reducedim(hello1, df, 1)


reduce(max, df, pick(:longitude))

path = Pkg.dir("JuliaDB", "test", "sample")
"/home/travis/.julia/v0.6/JuliaDB/test/sample"

sampledata = loadfiles(path, indexcols=["date", "ticker"])

JuliaDB.take_n(sampledata,100)


JuliaDB.take_n(df,1)

@time df1 = map(x -> x.latitude - x.longitude, df)

typeof(df1)

df1

@time reduce(+, map(x-> sum(x), df))

df.chunks[1]
fieldnames(df)

df1 = JuliaDB.take_n(df, 20)

typeof(df1)
fieldnames(df1)


fieldnames(df)

fieldnames(df.chunks)
df.chunks
df.chunks[1].chunktype

JuliaDB.keytype(df)
JuliaDB.first(df)

using Lazy



JuliaDB.take_n(x,1)

x.subdomains
using IndexedTables
methods(x.chunks[1])

JuliaDB.keys(x)
keys(x)

values(x)

x.subdomains

typeof(dd.data)
fieldnames(dd)

dd.data



names(df)

keys(df1.data[1])

function take_n(t::DTable, n)
    required = n
    getter(required, c) = collect(delayed(x->subtable(x, 1:min(required, length(x))))(c))

    i = 1
    top = getter(required, t.chunks[i])
    required = n - length(top)
    while required > 0 && 1 <= i < length(t.chunks)
        i += 1
        required = n - length(top)
        top = _merge(top, getter(required, t.chunks[i]))
    end
    return top
end


using DataFrames
names(df)

tdf = typeof(df)

methods(df)
fieldnames(df)

select(df, 1)

using CSV
df1 = CSV.read(files[1])
names(df1)

df2 = JuliaDB.take_n(df,1)
typeof(df2)
using DataFrames
convert(::DataFrame,df2)


methods(df2)
typeof(df2)

df2

df1 = CSV.read(files[1])



function readallcsv()
    CSV.read.(files);
end

@time df = readallcsv()

function readallcsv_vcat()
    reduce(vcat, CSV.read.(files))
end

@time df = readallcsv_vcat();

  # sapply(function(x) file.path(x,"ASDI","asdifpwaypoint.csv")) %>>%
  # lapply(fread)

using DataFrames, CSV
addprocs()
@everywhere using DataFrames, CSV
df = @time @parallel (vcat) for f in files
    gc()
    CSV.read(f)
end

df = nothing
gc()

using DataFrames, CSV, Feather
addprocs()
@everywhere using CSV, DataFrames, Feather

@time df_arr = pmap(enumerate(files)) do f
    # df = CSV.read(f)
    # ff = open(,"w")
    # Feather.write(ff,df)
    f
end
