module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Calculate the XOR of a and b
    wire ab_xor;
    assign ab_xor = a ^ b;

    // Calculate the XOR of c and d
    wire cd_xor;
    assign cd_xor = c ^ d;

    // Calculate the XOR of the two intermediate results
    assign out = ab_xor ^ cd_xor;

endmodule