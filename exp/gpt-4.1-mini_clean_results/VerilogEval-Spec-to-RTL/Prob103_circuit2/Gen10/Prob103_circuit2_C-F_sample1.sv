module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Compute intermediate XORs stepwise for clarity and modularity
    wire ab_xor = a ^ b;
    wire abc_xor = ab_xor ^ c;
    wire abcd_xor = abc_xor ^ d;

    // q is the even parity output (1 if number of ones is even)
    assign q = ~abcd_xor;

endmodule