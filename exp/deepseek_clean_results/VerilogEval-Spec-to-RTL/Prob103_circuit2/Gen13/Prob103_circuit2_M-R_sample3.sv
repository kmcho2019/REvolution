module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // q = 1 when number of 1s in {a,b,c,d} is even (even parity)
    // Implementation using reduction XOR and explicit inversion
    wire parity_bit;
    
    assign parity_bit = a ^ b ^ c ^ d;  // 1 if odd number of 1s
    assign q = ~parity_bit;             // Invert to get even parity

endmodule