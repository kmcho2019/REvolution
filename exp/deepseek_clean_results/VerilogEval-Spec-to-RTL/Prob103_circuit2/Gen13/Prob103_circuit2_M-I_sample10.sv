module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // q = 1 when number of 1s in {a,b,c,d} is even (even parity)
    // Equivalent to XOR of all inputs being 0
    // Truth table:
    // 0000:1 0001:0 0010:0 0011:1
    // 0100:0 0101:1 0110:1 0111:0
    // 1000:0 1001:1 1010:1 1011:0
    // 1100:1 1101:0 1110:0 1111:1
    assign q = ~(a ^ b ^ c ^ d);  // Direct XOR implementation without separate NOT

endmodule