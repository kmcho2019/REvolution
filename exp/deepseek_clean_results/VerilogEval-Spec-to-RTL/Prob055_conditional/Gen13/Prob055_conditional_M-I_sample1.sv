module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    wire [7:0] min_ab, min_cd;
    
    // First level of comparisons (parallel)
    assign min_ab = (a < b) ? a : b;
    assign min_cd = (c < d) ? c : d;
    
    // Second level comparison
    assign min = (min_ab < min_cd) ? min_ab : min_cd;

endmodule