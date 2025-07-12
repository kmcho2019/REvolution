module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement inversion and carry-in
    wire [63:0] B_comp = ~B;
    wire carry_in = 1'b1;

    // Segment parameters
    localparam SEG_WIDTH = 16;
    localparam NUM_SEG = 64/SEG_WIDTH;
    
    // Segment results and carries
    wire [SEG_WIDTH-1:0] sum_0 [NUM_SEG-1:0];
    wire [SEG_WIDTH-1:0] sum_1 [NUM_SEG-1:0];
    wire carry_seg [NUM_SEG:0];
    
    assign carry_seg[0] = carry_in;
    
    // Generate segments
    genvar i;
    generate
        for (i=0; i<NUM_SEG; i=i+1) begin : SEGMENTS
            // Current segment bounds
            localparam HI = (i+1)*SEG_WIDTH-1;
            localparam LO = i*SEG_WIDTH;
            
            // Conditional sum computation
            wire [SEG_WIDTH-1:0] p = A[LO+:SEG_WIDTH] ^ B_comp[LO+:SEG_WIDTH];
            wire [SEG_WIDTH-1:0] g = A[LO+:SEG_WIDTH] & B_comp[LO+:SEG_WIDTH];
            
            // Compute both possible sums (carry=0 and carry=1)
            assign sum_0[i] = p ^ {SEG_WIDTH{1'b0}};  // carry=0
            assign sum_1[i] = p ^ {1'b1, {SEG_WIDTH-1{1'b0}}};  // carry=1
            
            // Generate segment carry-out
            wire g_block = &g;  // Block generate
            wire p_block = ^p;  // Block propagate
            assign carry_seg[i+1] = g_block | (p_block & carry_seg[i]);
            
            // Select correct sum based on carry-in
            assign result[LO+:SEG_WIDTH] = carry_seg[i] ? sum_1[i] : sum_0[i];
        end
    endgenerate

    // Enhanced overflow detection
    wire early_overflow = (A[63] != B[63]) && 
                         ((A[63:48] == {SEG_WIDTH{1'b1}}) || 
                         (B_comp[63:48] == {SEG_WIDTH{1'b1}}));
    
    assign overflow = early_overflow || 
                     ((A[63] != B[63]) && (A[63] != result[63]));

    /* Overflow Logic:
     * 1. Early detection when extreme values detected in MSB segment
     * 2. Traditional sign comparison for all other cases
     * Combines both methods for comprehensive coverage
     */
endmodule