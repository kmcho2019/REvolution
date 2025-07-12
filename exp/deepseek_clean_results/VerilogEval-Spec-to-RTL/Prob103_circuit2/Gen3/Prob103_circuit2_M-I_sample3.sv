module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Calculate parity using XOR chain
    wire parity = a ^ b ^ c ^ d;
    
    // Detect all zeros case
    wire all_zeros = ~(a | b | c | d);
    
    // q is 1 when either all zeros or even parity
    assign q = all_zeros | ~parity;
endmodule