module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [64:0] carry;  // Extended to include final carry-out
    
    // Initialize carry chain
    assign carry[0] = 1'b1;  // +1 for two's complement
    
    // Ripple-carry subtraction with explicit chaining
    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin : SUB_BITS
            assign result[i] = A[i] ^ B_comp[i] ^ carry[i];
            assign carry[i+1] = (A[i] & B_comp[i]) | 
                              ((A[i] ^ B_comp[i]) & carry[i]);
        end
    endgenerate

    // Overflow occurs when:
    // 1. Subtracting negative from positive gives negative result (positive overflow)
    // 2. Subtracting positive from negative gives positive result (negative overflow)
    assign overflow = (A[63] ^ B[63]) && (A[63] ^ result[63]);

endmodule