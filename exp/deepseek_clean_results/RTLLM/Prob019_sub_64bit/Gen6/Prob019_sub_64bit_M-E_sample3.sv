module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Segment the 64-bit inputs into 4x16-bit chunks
    wire [15:0] A_seg [3:0];
    wire [15:0] B_seg [3:0];
    wire [15:0] res_seg [3:0];
    wire [3:0] seg_overflow;
    wire [3:0] seg_sign;

    // Segment assignment
    assign A_seg[0] = A[15:0];
    assign A_seg[1] = A[31:16];
    assign A_seg[2] = A[47:32];
    assign A_seg[3] = A[63:48];
    
    assign B_seg[0] = B[15:0];
    assign B_seg[1] = B[31:16];
    assign B_seg[2] = B[47:32];
    assign B_seg[3] = B[63:48];

    // Generate subtraction segments with local overflow detection
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : SUB_SEG
            // Local subtraction
            assign res_seg[i] = A_seg[i] - B_seg[i];
            
            // Local sign bits
            assign seg_sign[i] = res_seg[i][15];
            
            // Local overflow detection
            assign seg_overflow[i] = 
                (A_seg[i][15] != B_seg[i][15]) && 
                (A_seg[i][15] != seg_sign[i]);
        end
    endgenerate

    // Combine results
    assign result = {res_seg[3], res_seg[2], res_seg[1], res_seg[0]};

    // Final overflow detection (OR of all segment overflows)
    assign overflow = |seg_overflow;

endmodule