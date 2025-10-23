module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // 4-bit carry-lookahead implementation
    wire [15:0] group_propagate;
    wire [15:0] group_generate;
    wire [16:0] group_carry;
    
    // Initialize carry-in for subtraction
    assign group_carry[0] = 1'b1;
    
    // Generate group propagate/generate terms
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : cla_groups
            // Calculate group propagate (P) and generate (G)
            wire [3:0] P = A[i*4 +:4] ^ ~B[i*4 +:4];
            wire [3:0] G = A[i*4 +:4] & ~B[i*4 +:4];
            
            // Group propagate is AND of individual propagates
            assign group_propagate[i] = &P;
            
            // Group generate uses carry lookahead formula
            assign group_generate[i] = G[3] | 
                                     (P[3] & G[2]) | 
                                     (P[3] & P[2] & G[1]) | 
                                     (P[3] & P[2] & P[1] & G[0]);
            
            // Calculate group carry
            assign group_carry[i+1] = group_generate[i] | 
                                    (group_propagate[i] & group_carry[i]);
            
            // Calculate result bits
            assign result[i*4 +:4] = P ^ {group_carry[i], 
                                         P[0] & group_carry[i],
                                         P[1:0] & {2{group_carry[i]}},
                                         P[2:0] & {3{group_carry[i]}};
        end
    endgenerate

    /* Optimized Overflow Detection:
     * - Use carry-out (group_carry[16]) and sign bits
     * - Overflow occurs when carry-out differs from sign bit
     */
    assign overflow = group_carry[16] ^ result[63];

endmodule