module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Directly compute parity of all inputs
    assign out = a ^ b ^ c ^ d;
endmodule