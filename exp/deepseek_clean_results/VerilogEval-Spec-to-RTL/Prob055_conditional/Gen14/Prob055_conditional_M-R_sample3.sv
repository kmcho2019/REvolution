module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Single assign statement with nested conditionals
    assign min = (((a < b) ? a : b) < c ? ((a < b) ? a : b) : c) < d ? 
                 (((a < b) ? a : b) < c ? ((a < b) ? a : b) : c) : d;

endmodule