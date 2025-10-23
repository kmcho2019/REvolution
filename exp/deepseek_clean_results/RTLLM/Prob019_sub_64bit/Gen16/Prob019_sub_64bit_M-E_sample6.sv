module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Constants for readability
    localparam SEG_WIDTH = 8;
    localparam NUM_SEG = 64/SEG_WIDTH;
    
    // Two's complement inversion
    wire [63:0] B_comp = ~B;
    wire [63:0] B_neg = B_comp + 1;  // Complete negation
    
    // Segment results (0=carry0, 1=carry1)
    wire [NUM_SEG-1:0] seg_carry_out0, seg_carry_out1;
    wire [63:0] seg_result0, seg_result1;
    
    // Prefix carry network
    wire [NUM_SEG:0] prefix_carry;
    assign prefix_carry[0] = 1'b1;  // Initial carry-in for subtraction
    
    // Generate segments
    genvar i;
    generate
        for (i=0; i<NUM_SEG; i=i+1) begin : SEGMENTS
            // Segment boundaries
            localparam MSB = (i+1)*SEG_WIDTH-1;
            localparam LSB = i*SEG_WIDTH;
            
            // Compute both possible results
            wire [SEG_WIDTH:0] sum0 = A[LSB+:SEG_WIDTH] + B_neg[LSB+:SEG_WIDTH] + 0;
            wire [SEG_WIDTH:0] sum1 = A[LSB+:SEG_WIDTH] + B_neg[LSB+:SEG_WIDTH] + 1;
            
            // Store both possible results
            assign seg_result0[LSB+:SEG_WIDTH] = sum0[SEG_WIDTH-1:0];
            assign seg_result1[LSB+:SEG_WIDTH] = sum1[SEG_WIDTH-1:0];
            assign seg_carry_out0[i] = sum0[SEG_WIDTH];
            assign seg_carry_out1[i] = sum1[SEG_WIDTH];
            
            // Prefix carry computation (parallel)
            wire seg_prop = &(A[LSB+:SEG_WIDTH] ^ B_neg[LSB+:SEG_WIDTH]);
            wire seg_gen = |(A[LSB+:SEG_WIDTH] & B_neg[LSB+:SEG_WIDTH]);
            
            // Carry prefix update
            assign prefix_carry[i+1] = seg_gen | (seg_prop & prefix_carry[i]);
            
            // Select correct result
            assign result[LSB+:SEG_WIDTH] = prefix_carry[i] ? 
                                          seg_result1[LSB+:SEG_WIDTH] : 
                                          seg_result0[LSB+:SEG_WIDTH];
            
            // Segment-level overflow detection
            wire seg_overflow = (A[MSB] != B[MSB]) && 
                               (A[MSB] != (prefix_carry[i] ? 
                                          seg_result1[MSB] : 
                                          seg_result0[MSB]));
        end
    endgenerate
    
    // Parallel overflow detection tree
    wire [NUM_SEG-1:0] seg_overflow;
    assign overflow = |seg_overflow;
    
    // Final overflow check (redundant but ensures correctness)
    wire final_overflow = (A[63] != B[63]) && (A[63] != result[63]);
    assert (overflow == final_overflow) else $error("Overflow mismatch");

endmodule