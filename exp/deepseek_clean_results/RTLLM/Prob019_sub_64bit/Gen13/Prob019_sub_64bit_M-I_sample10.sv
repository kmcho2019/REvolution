module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    // 4-bit carry-lookahead subtractor implementation
    wire [15:0] group_propagate;
    wire [15:0] group_generate;
    wire [16:0] group_carry;
    assign group_carry[0] = 1'b0;  // No input borrow

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : cla_blocks
            // 4-bit subtractor block
            wire [3:0] block_diff;
            wire [3:0] block_propagate;
            wire [3:0] block_generate;
            wire [4:0] block_carry;
            
            assign block_carry[0] = group_carry[i];
            
            // Individual bit subtractors
            for (genvar j = 0; j < 4; j = j + 1) begin : bit_sub
                localparam idx = i*4 + j;
                assign block_diff[j] = A[idx] ^ B[idx] ^ block_carry[j];
                assign block_propagate[j] = A[idx] ^ B[idx];
                assign block_generate[j] = (~A[idx] & B[idx]) | (~A[idx] & block_carry[j]) | (B[idx] & block_carry[j]);
                assign block_carry[j+1] = block_generate[j];
            end
            
            // Block-level carry lookahead
            assign group_propagate[i] = &block_propagate;
            assign group_generate[i] = block_generate[3] | 
                                     (block_propagate[3] & block_generate[2]) | 
                                     (block_propagate[3] & block_propagate[2] & block_generate[1]) | 
                                     (block_propagate[3] & block_propagate[2] & block_propagate[1] & block_generate[0]);
            
            assign group_carry[i+1] = group_generate[i] | (group_propagate[i] & group_carry[i]);
            
            // Assign result bits
            assign result[i*4 +: 4] = block_diff;
        end
    endgenerate

    // Overflow detection (unchanged optimal logic)
    wire operands_diff_sign = A[63] != B[63];
    wire result_diff_sign = A[63] != result[63];
    assign overflow = operands_diff_sign && result_diff_sign;

endmodule