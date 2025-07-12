module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Directly implement 1-bit XNOR using built-in operator for minimal area and power
    assign out = a ~^ b;
endmodule