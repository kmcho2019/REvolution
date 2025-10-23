module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

wire [7:0] carry_out;
wire [7:0] segment_overflow;

// Generate 8-bit subtractor segments with carry lookahead
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : SUB_SEGMENTS
        wire [7:0] a_seg = A[(i*8)+7 : i*8];
        wire [7:0] b_seg = B[(i*8)+7 : i*8];
        wire carry_in = (i == 0) ? 1'b1 : carry_out[i-1];
        
        // 8-bit subtractor with carry lookahead
        assign {carry_out[i], result[(i*8)+7 : i*8]} = 
               {1'b0, a_seg} - {1'b0, b_seg} - {8'b0, carry_in};
        
        // Local overflow detection for each segment
        assign segment_overflow[i] = 
               (a_seg[7] ^ b_seg[7]) & (a_seg[7] ^ result[(i*8)+7]);
    end
endgenerate

// Global overflow detection combines segment overflows with sign analysis
wire a_sign = A[63];
wire b_sign = B[63];
wire result_sign = result[63];

assign overflow = |segment_overflow | 
                 ((~a_sign & b_sign & result_sign) | 
                  (a_sign & ~b_sign & ~result_sign));

endmodule