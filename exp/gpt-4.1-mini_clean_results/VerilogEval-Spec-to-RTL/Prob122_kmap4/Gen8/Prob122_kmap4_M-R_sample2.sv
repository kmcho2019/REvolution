module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire parity;
    assign parity = a ^ b ^ c ^ d;
    assign out = parity;
endmodule