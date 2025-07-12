module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Direct single-bit XNOR using built-in operator to flatten hierarchy
    assign out = ~(a ^ b);
endmodule