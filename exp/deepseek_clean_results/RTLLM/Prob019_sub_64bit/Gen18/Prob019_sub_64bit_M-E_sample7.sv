module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Segment parameters
    localparam SEG_WIDTH = 8;
    localparam NUM_SEG = 64/SEG_WIDTH;
    
    // Segment results (0: carry=0, 1: carry=1)
    wire [SEG_WIDTH-1:0] seg_res [0:NUM_SEG-1][0:1];
    wire [NUM_SEG-1:0] seg_cout;
    
    // Intermediate carries
    wire [NUM_SEG:0] carry_chain;
    assign carry_chain[0] = 1'b1; // Subtraction carry-in
    
    // Generate all segments
    genvar i;
    generate
        for (i=0; i<NUM_SEG; i=i+1) begin : SEGMENTS
            // Compute both possible results for this segment
            wire [SEG_WIDTH:0] sum0, sum1;
            assign sum0 = A[i*SEG_WIDTH +: SEG_WIDTH] + (~B[i*SEG_WIDTH +: SEG_WIDTH]) + 0;
            assign sum1 = A[i*SEG_WIDTH +: SEG_WIDTH] + (~B[i*SEG_WIDTH +: SEG_WIDTH]) + 1;
            
            // Store both possible results
            assign seg_res[i][0] = sum0[SEG_WIDTH-1:0];
            assign seg_res[i][1] = sum1[SEG_WIDTH-1:0];
            assign seg_cout[i] = sum1[SEG_WIDTH]; // carry-out when carry-in=1
            
            // Select correct result based on previous carry
            assign result[i*SEG_WIDTH +: SEG_WIDTH] = carry_chain[i] ? seg_res[i][1] : seg_res[i][0];
            
            // Propagate carry
            assign carry_chain[i+1] = carry_chain[i] ? seg_cout[i] : sum0[SEG_WIDTH];
        end
    endgenerate

    /* Early Overflow Detection:
     * 1. Check if signs of A and B differ (potential overflow)
     * 2. Predict result sign based on MSB segment behavior
     * 3. Compare with actual A sign
     */
    wire predicted_sign = carry_chain[NUM_SEG-1] ? 
                        seg_res[NUM_SEG-1][1][SEG_WIDTH-1] : 
                        seg_res[NUM_SEG-1][0][SEG_WIDTH-1];
    
    assign overflow = (A[63] ^ B[63]) & (A[63] ^ predicted_sign);

endmodule