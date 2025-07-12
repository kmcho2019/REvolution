module TopModule(
    input  wire a,
    input  wire b,
    output wire out
);
    // Direct single-bit XNOR operation using built-in operator for minimal area and power
    assign out = ~(a ^ b);
endmodule