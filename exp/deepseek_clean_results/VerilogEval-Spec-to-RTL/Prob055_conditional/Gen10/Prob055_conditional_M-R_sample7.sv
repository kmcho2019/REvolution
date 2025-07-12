module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Single assignment with nested ternary operators
    assign min = ((a < b ? a : b) < (c < d ? c : d)) ? 
                 (a < b ? a : b) : 
                 (c < d ? c : d);

endmodule