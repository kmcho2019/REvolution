module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire ad_xor;
    wire bc_xor;

    assign ad_xor = a ^ d;
    assign bc_xor = b ^ c;
    assign out = ad_xor ^ bc_xor;
endmodule