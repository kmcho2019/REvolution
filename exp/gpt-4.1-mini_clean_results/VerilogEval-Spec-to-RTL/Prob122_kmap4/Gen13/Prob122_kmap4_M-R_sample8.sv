module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire parity_all;

    // Single-step XOR of all inputs using one assign statement
    assign parity_all = a ^ b ^ c ^ d;
    assign out = parity_all;
endmodule