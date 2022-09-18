using BigIdiot, Test

x = 1
d = [1 2 3 4 4 4 6 7 8 9]

@testset "suitor_check tests" begin
    @test_nowarn suitor_check(x,d)
end
