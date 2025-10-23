module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Compute parity using XOR chain
    wire parity_ab = a ^ b;
    wire parity_abc = parity_ab ^ c;
    wire parity_abcd = parity_abc ^ d;
    
    // Output is 1 when even number of inputs are 1 (XOR chain result is 0)
    assign q = ~parity_abcd;

endmodule