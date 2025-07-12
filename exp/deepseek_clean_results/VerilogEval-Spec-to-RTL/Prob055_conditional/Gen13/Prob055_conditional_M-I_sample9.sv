module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Single-stage minimum finding with nested conditionals
    assign min = (a < b && a < c && a < d) ? a :
                (b < c && b < d) ? b :
                (c < d) ? c : d;

endmodule