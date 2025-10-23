module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

// Early overflow prediction (computed in parallel with subtraction)
wire A_sign = A[63];
wire B_sign = B[63];
wire predicted_overflow = (A_sign ^ ~B_sign) & (A_sign ^ result[63]);

// 16x4-bit carry-save subtractor blocks
wire [63:0] B_comp = ~B + 1'b1; // Two's complement of B
wire [15:0] carry_chain;

genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : sub_blocks
        wire [3:0] A_block = A[i*4 +: 4];
        wire [3:0] B_block = B_comp[i*4 +: 4];
        wire [3:0] sum;
        wire carry_out;
        
        if (i == 0) begin
            // First block with carry-in = 1 (for two's complement)
            assign {carry_out, sum} = A_block + B_block + 1'b1;
        end else begin
            // Subsequent blocks with carry from previous
            assign {carry_out, sum} = A_block + B_block + carry_chain[i-1];
        end
        
        assign carry_chain[i] = carry_out;
        assign result[i*4 +: 4] = sum;
    end
endgenerate

// Final overflow determination
assign overflow = predicted_overflow & (carry_chain[15] ^ carry_chain[14]);

endmodule