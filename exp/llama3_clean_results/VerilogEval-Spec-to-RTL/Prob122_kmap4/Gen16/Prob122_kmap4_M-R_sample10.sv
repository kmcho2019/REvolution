module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire ab_xor;
    wire ab_c_xor;

    assign ab_xor = a ^ b;
    assign ab_c_xor = ab_xor ^ c;
    assign out = ab_c_xor ^ d;

endmodule