module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Directly compute the 4-input parity by XORing all inputs.
    // This reduces intermediate net switching and simplifies netlist.
    assign out = a ^ b ^ c ^ d;
endmodule