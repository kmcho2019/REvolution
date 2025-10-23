module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Segment definitions
    wire [7:0] segment_result [7:0];
    wire [7:0] carry_prop;
    wire [7:0] carry_gen;
    wire [7:0] segment_carry_in;
    wire [7:0] segment_carry_out;
    
    // Compute B's two's complement (for subtraction)
    wire [63:0] B_comp = ~B + 1;
    
    // Process each 8-bit segment
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : SEGMENTS
            // Current segment boundaries
            localparam hi = i*8 + 7;
            localparam lo = i*8;
            
            // Carry-select implementation
            wire [7:0] res0 = A[hi:lo] + B_comp[hi:lo] + 1'b0;
            wire [7:0] res1 = A[hi:lo] + B_comp[hi:lo] + 1'b1;
            
            // Carry propagation and generation
            assign carry_prop[i] = &(A[hi:lo] ^ B_comp[hi:lo]);
            assign carry_gen[i] = |(A[hi:lo] & B_comp[hi:lo]);
            
            // Carry selection
            assign segment_carry_in[i] = (i == 0) ? 1'b0 : segment_carry_out[i-1];
            assign segment_result[i] = segment_carry_in[i] ? res1 : res0;
            assign segment_carry_out[i] = carry_gen[i] | (carry_prop[i] & segment_carry_in[i]);
            
            // Assign final result
            assign result[hi:lo] = segment_result[i];
        end
    endgenerate
    
    // Early overflow prediction
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire R_sign = result[63];
    
    // Overflow occurs when:
    // 1. Subtracting different signs (A_sign ^ B_sign)
    // 2. Result sign doesn't match expected (A_sign ^ R_sign)
    // Special case for MSB segment
    assign overflow = (A_sign ^ B_sign) & (A_sign ^ R_sign) & 
                     (segment_carry_out[6] ^ segment_carry_out[7]);

endmodule