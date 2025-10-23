module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Direct 8-bit mux implementation
    assign out = sel ? b : a;

endmodule