module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Single vectorized mux operation
    assign out = sel ? a : b;

endmodule