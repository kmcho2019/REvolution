module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // First level comparisons (parallel)
    wire [7:0] min_ab = (a < b) ? a : b;
    wire [7:0] min_cd = (c < d) ? c : d;
    
    // Final comparison
    assign min = min_ab < min_cd ? min_ab : min_cd;

endmodule