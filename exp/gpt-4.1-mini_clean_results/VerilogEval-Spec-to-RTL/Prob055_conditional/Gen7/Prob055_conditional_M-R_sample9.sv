module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);
    // Direct chained comparison using nested ternary operators to find minimum of four values
    assign min = (a < b) ? ((a < c) ? ((a < d) ? a : d) : ((c < d) ? c : d))
                         : ((b < c) ? ((b < d) ? b : d) : ((c < d) ? c : d));

endmodule