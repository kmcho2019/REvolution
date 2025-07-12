module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Calculate parity using XOR chain
    wire parity = a ^ b ^ c ^ d;
    
    // q is 1 when all inputs are 0 or when parity is 0 (even number of 1s)
    assign q = ~(a | b | c | d) | ~parity;
endmodule