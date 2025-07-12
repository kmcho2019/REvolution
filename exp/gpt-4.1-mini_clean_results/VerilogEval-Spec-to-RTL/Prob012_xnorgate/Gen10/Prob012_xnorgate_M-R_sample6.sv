module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Direct assign statement implementing 1-bit XNOR using built-in operator
    assign out = a ~^ b;
endmodule