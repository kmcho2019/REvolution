module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

// Early overflow prediction
wire A_sign = A[63];
wire B_sign = B[63];
wire potential_pos_overflow = ~A_sign & B_sign;
wire potential_neg_overflow = A_sign & ~B_sign;

// Hierarchical subtraction (16-bit blocks)
wire [3:0] carry_out;
wire [63:0] B_comp = ~B + 1; // Two's complement of B

// First 16-bit block
assign {carry_out[0], result[15:0]} = A[15:0] + B_comp[15:0];

// Subsequent blocks with carry propagation
genvar i;
generate
    for (i = 1; i < 4; i = i + 1) begin : SUB_BLOCKS
        wire [15:0] block_A = A[i*16 +: 16];
        wire [15:0] block_B_comp = B_comp[i*16 +: 16];
        assign {carry_out[i], result[i*16 +: 16]} = block_A + block_B_comp + carry_out[i-1];
    end
endgenerate

// Final overflow determination
wire result_sign = result[63];
assign overflow = (potential_pos_overflow & result_sign) | 
                  (potential_neg_overflow & ~result_sign);

endmodule