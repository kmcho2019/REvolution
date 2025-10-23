module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum bits and intermediate carries
    wire [3:0] sum_bits;
    wire [3:0] carry;
    
    // Bit 0
    assign {carry[0], sum_bits[0]} = A[0] + B[0] + Cin;
    
    // Bit 1
    assign {carry[1], sum_bits[1]} = A[1] + B[1] + carry[0];
    
    // Bit 2
    assign {carry[2], sum_bits[2]} = A[2] + B[2] + carry[1];
    
    // Bit 3
    assign {carry[3], sum_bits[3]} = A[3] + B[3] + carry[2];
    
    // Optimized correction detection (carry out OR sum > 9)
    // Equivalent to: carry[3] OR (sum_bits[3] AND (sum_bits[2] OR sum_bits[1]))
    wire correction_needed = carry[3] | (sum_bits[3] & (sum_bits[2] | sum_bits[1]));
    
    // Conditional correction (+6) implemented as:
    // - Flip bit 3 if correction needed
    // - Flip bit 1 if correction needed
    // - Bit 2 remains same (no change needed for +6)
    // - Bit 0 remains same
    assign Sum[0] = sum_bits[0];
    assign Sum[1] = sum_bits[1] ^ correction_needed;
    assign Sum[2] = sum_bits[2];
    assign Sum[3] = sum_bits[3] ^ correction_needed;
    
    // Carry out
    assign Cout = correction_needed;

endmodule