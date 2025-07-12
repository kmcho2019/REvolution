module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Direct 1-bit XNOR using built-in operator for optimal PPA with no extra hierarchy
    assign out = a ~^ b;
endmodule