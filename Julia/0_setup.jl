using CSV
settings = CSV.read("../settings.csv")
data_path = get(settings[:data_path][1]