module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire ab_xor;
    wire cd_xor;

    // XOR pairs of inputs first
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;

    // XOR the intermediate results to get the final output
    assign out = ab_xor ^ cd_xor;
endmodule