module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement conversion
    wire [63:0] B_comp = ~B;
    wire [63:0] B_neg = B_comp + 1;  // Complete negation
    
    // Segment parameters
    localparam SEG_WIDTH = 8;
    localparam NUM_SEG = 64/SEG_WIDTH;
    
    // Segment results storage
    wire [SEG_WIDTH-1:0] seg_res0 [NUM_SEG-1:0]; // Results assuming carry=0
    wire [SEG_WIDTH-1:0] seg_res1 [NUM_SEG-1:0]; // Results assuming carry=1
    wire [NUM_SEG-1:0] seg_cout0, seg_cout1;     // Segment carry-outs
    
    // Overflow detection signals
    wire [NUM_SEG-1:0] seg_ovf0, seg_ovf1;       // Segment overflow flags
    
    // Generate all segments
    genvar i;
    generate
        for (i=0; i<NUM_SEG; i=i+1) begin : SEGMENTS
            localparam hi = (i+1)*SEG_WIDTH-1;
            localparam lo = i*SEG_WIDTH;
            
            // Compute both possible results in parallel
            assign {seg_cout0[i], seg_res0[i]} = A[lo+:SEG_WIDTH] + B_neg[lo+:SEG_WIDTH] + 0;
            assign {seg_cout1[i], seg_res1[i]} = A[lo+:SEG_WIDTH] + B_neg[lo+:SEG_WIDTH] + 1;
            
            // Speculative overflow detection for each segment
            assign seg_ovf0[i] = (i == NUM_SEG-1) ? 
                (A[63] ^ B[63]) && (A[63] ^ seg_res0[i][SEG_WIDTH-1]) : 1'b0;
            assign seg_ovf1[i] = (i == NUM_SEG-1) ? 
                (A[63] ^ B[63]) && (A[63] ^ seg_res1[i][SEG_WIDTH-1]) : 1'b0;
        end
    endgenerate
    
    // Carry propagation and result selection
    wire [NUM_SEG:0] carry_chain;
    assign carry_chain[0] = 1'b1; // Initial carry-in for subtraction
    
    generate
        for (i=0; i<NUM_SEG; i=i+1) begin : SELECT
            // Select between precomputed results based on carry
            assign result[i*SEG_WIDTH +: SEG_WIDTH] = carry_chain[i] ? 
                seg_res1[i] : seg_res0[i];
            assign carry_chain[i+1] = carry_chain[i] ? 
                seg_cout1[i] : seg_cout0[i];
        end
    endgenerate
    
    // Final overflow selection
    assign overflow = carry_chain[NUM_SEG-1] ? 
        seg_ovf1[NUM_SEG-1] : seg_ovf0[NUM_SEG-1];

    /* Implementation Notes:
     * 1. Hybrid carry-select architecture provides parallel computation
     * 2. Speculative overflow detection reduces critical path
     * 3. Only MSB segment contributes to final overflow condition
     * 4. Balanced 8-bit segments optimize for both speed and area
     */
endmodule