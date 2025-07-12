module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Single-level comparison with parallel evaluation
    assign min = (a < b && a < c && a < d) ? a :
                 (b < c && b < d) ? b :
                 (c < d) ? c : d;

endmodule