module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Direct single-bit XNOR implementation with built-in operator
    assign out = a ~^ b;
endmodule