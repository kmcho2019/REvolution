module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Dynamic operand inversion
    wire [63:0] B_inv = B ^ {64{1'b1}};
    wire [63:0] B_adj = B_inv + 1;

    // Segment parameters
    localparam SEG_WIDTH = 8;
    localparam NUM_SEG = 64/SEG_WIDTH;
    
    // Segment results and carries
    wire [SEG_WIDTH-1:0] seg_res [NUM_SEG-1:0];
    wire [NUM_SEG-1:0] seg_cout;
    wire [NUM_SEG-1:0] seg_cin;

    // First segment special handling
    wire [SEG_WIDTH:0] first_sum = A[SEG_WIDTH-1:0] + B_adj[SEG_WIDTH-1:0];
    assign seg_res[0] = first_sum[SEG_WIDTH-1:0];
    assign seg_cout[0] = first_sum[SEG_WIDTH];
    assign seg_cin[0] = 1'b0;

    // Middle segments with conditional carry select
    genvar i;
    generate
        for (i=1; i<NUM_SEG; i=i+1) begin : SEGMENTS
            // Kogge-Stone prefix adder for current segment
            wire [SEG_WIDTH:0] sum0 = A[i*SEG_WIDTH +: SEG_WIDTH] + B_adj[i*SEG_WIDTH +: SEG_WIDTH];
            wire [SEG_WIDTH:0] sum1 = A[i*SEG_WIDTH +: SEG_WIDTH] + B_adj[i*SEG_WIDTH +: SEG_WIDTH] + 1;
            
            // Carry select
            assign seg_res[i] = seg_cout[i-1] ? sum1[SEG_WIDTH-1:0] : sum0[SEG_WIDTH-1:0];
            assign seg_cout[i] = seg_cout[i-1] ? sum1[SEG_WIDTH] : sum0[SEG_WIDTH];
            assign seg_cin[i] = seg_cout[i-1];
        end
    endgenerate

    // Combine segment results
    generate
        for (i=0; i<NUM_SEG; i=i+1) begin : COMBINE
            assign result[i*SEG_WIDTH +: SEG_WIDTH] = seg_res[i];
        end
    endgenerate

    // Enhanced overflow detection
    wire ovf_sign = (A[63] ^ B[63]) && (A[63] ^ result[63]);
    wire ovf_carry = (seg_cout[NUM_SEG-1] ^ seg_cin[NUM_SEG-1]);
    assign overflow = ovf_sign | ovf_carry;

endmodule