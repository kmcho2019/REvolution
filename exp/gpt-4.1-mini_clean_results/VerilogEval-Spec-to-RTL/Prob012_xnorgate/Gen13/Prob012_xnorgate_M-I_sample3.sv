module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Direct 1-bit XNOR using built-in operator without submodule to minimize area and power
    assign out = a ~^ b;
endmodule