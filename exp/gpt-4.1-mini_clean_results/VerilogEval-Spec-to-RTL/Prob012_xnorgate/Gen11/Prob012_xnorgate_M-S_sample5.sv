module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Direct 1-bit XNOR using built-in operator without extra submodule
    assign out = a ~^ b;
endmodule