module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Hierarchical carry-lookahead subtraction (A - B = A + ~B + 1)
    wire [63:0] B_comp = ~B;
    wire [16:0] group_carry;  // 64 bits / 4 = 16 groups
    assign group_carry[0] = 1'b1;  // +1 for two's complement

    genvar i, j;
    generate
        for (i=0; i<16; i=i+1) begin : group_loop
            // 4-bit carry-lookahead units
            wire [3:0] p, g;
            wire [4:0] carry;
            assign carry[0] = group_carry[i];
            
            for (j=0; j<4; j=j+1) begin : bit_loop
                localparam idx = i*4 + j;
                assign p[j] = A[idx] ^ B_comp[idx];
                assign g[j] = A[idx] & B_comp[idx];
                assign result[idx] = p[j] ^ carry[j];
                
                // Carry lookahead within group
                assign carry[j+1] = g[j] | (p[j] & carry[j]);
            end
            
            // Group propagate and generate
            wire P_group = &p;
            wire G_group = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
            
            // Next group carry
            assign group_carry[i+1] = G_group | (P_group & group_carry[i]);
        end
    endgenerate

    // Optimized overflow detection
    wire operands_diff_sign = A[63] ^ B[63];
    wire result_diff_sign = A[63] ^ result[63];
    assign overflow = operands_diff_sign & result_diff_sign;

endmodule