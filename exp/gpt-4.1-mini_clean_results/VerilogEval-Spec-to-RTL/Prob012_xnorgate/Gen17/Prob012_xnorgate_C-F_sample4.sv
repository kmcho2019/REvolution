module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Direct, minimal, and efficient implementation of 1-bit XNOR
    assign out = a ~^ b;
endmodule