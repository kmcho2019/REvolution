module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire xor1 = a ^ b;
    wire xor2 = c ^ d;

    assign out = xor1 ^ xor2;
endmodule