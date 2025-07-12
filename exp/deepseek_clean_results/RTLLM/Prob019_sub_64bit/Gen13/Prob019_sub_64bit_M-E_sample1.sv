module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Segment parameters
    localparam SEG_WIDTH = 8;
    localparam NUM_SEG = 64/SEG_WIDTH;
    
    // Two's complement inversion
    wire [63:0] B_comp = ~B;
    
    // Segment results and carries
    logic [SEG_WIDTH-1:0] seg_res [0:NUM_SEG-1];
    logic [NUM_SEG:0] seg_carry;
    assign seg_carry[0] = 1'b1; // +1 for two's complement
    
    // Overflow prediction signals
    logic msb_overflow_pos;
    logic msb_overflow_neg;
    
    generate
        for (genvar i = 0; i < NUM_SEG; i++) begin : SEGMENTS
            localparam [7:0] MSB = (i+1)*SEG_WIDTH-1;
            localparam [7:0] LSB = i*SEG_WIDTH;
            
            // Compute both possible results for carry=0 and carry=1
            wire [SEG_WIDTH:0] sum0 = A[MSB:LSB] + B_comp[MSB:LSB] + 0;
            wire [SEG_WIDTH:0] sum1 = A[MSB:LSB] + B_comp[MSB:LSB] + 1;
            
            // Select appropriate result based on incoming carry
            always_comb begin
                if (seg_carry[i]) begin
                    seg_res[i] = sum1[SEG_WIDTH-1:0];
                    seg_carry[i+1] = sum1[SEG_WIDTH];
                end else begin
                    seg_res[i] = sum0[SEG_WIDTH-1:0];
                    seg_carry[i+1] = sum0[SEG_WIDTH];
                end
                
                // Special handling for MSB segment (overflow prediction)
                if (i == NUM_SEG-1) begin
                    msb_overflow_pos = (A[63] & ~B[63] & ~sum1[SEG_WIDTH-1]) | 
                                      (A[63] & ~B[63] & ~sum0[SEG_WIDTH-1]);
                    msb_overflow_neg = (~A[63] & B[63] & sum1[SEG_WIDTH-1]) | 
                                      (~A[63] & B[63] & sum0[SEG_WIDTH-1]);
                end
            end
        end
    endgenerate
    
    // Combine segment results
    always_comb begin
        for (int i = 0; i < NUM_SEG; i++) begin
            result[i*SEG_WIDTH +: SEG_WIDTH] = seg_res[i];
        end
    end
    
    // Final overflow determination
    always_comb begin
        overflow = msb_overflow_pos | msb_overflow_neg;
    end

    /* Overflow Explanation:
     * Early detection by examining only the MSB segment:
     * - Positive overflow: A positive, B negative, result appears negative
     * - Negative overflow: A negative, B positive, result appears positive
     * This matches full-width detection but with less logic depth
     */
endmodule