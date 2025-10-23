module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // First round comparisons (parallel)
    wire [7:0] round1_min_ab = (a < b) ? a : b;
    wire [7:0] round1_min_cd = (c < d) ? c : d;
    
    // Final comparison
    assign min = (round1_min_ab < round1_min_cd) ? round1_min_ab : round1_min_cd;

endmodule