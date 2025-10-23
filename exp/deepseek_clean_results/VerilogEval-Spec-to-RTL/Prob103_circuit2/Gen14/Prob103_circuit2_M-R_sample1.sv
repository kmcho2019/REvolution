module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Calculate parity using parallel XOR operations
    wire parity_bit = a ^ b ^ c ^ d;
    
    // Output is 1 when even number of inputs are 1 (XNOR of parity_bit)
    assign q = ~parity_bit;

endmodule