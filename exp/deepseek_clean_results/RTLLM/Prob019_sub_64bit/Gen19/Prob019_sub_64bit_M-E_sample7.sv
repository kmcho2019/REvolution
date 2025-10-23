module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [7:0] carry_out;
    wire [7:0][7:0] sum0, sum1; // 8 blocks of 8-bit sums (0=no carry, 1=carry)
    wire [7:0] block_carry;

    // Generate 8 blocks of 8-bit conditional sum adders
    genvar i;
    generate
        for (i=0; i<64; i=i+8) begin : CSA_BLOCKS
            // Compute both possible sums in parallel
            wire [7:0] sum0_temp = A[i+:8] + B_comp[i+:8] + 8'b0;
            wire [7:0] sum1_temp = A[i+:8] + B_comp[i+:8] + 8'b1;
            
            // Store both possible results
            assign sum0[i/8] = sum0_temp;
            assign sum1[i/8] = sum1_temp;
            
            // Compute block carry-out for both cases
            wire cout0 = (A[i+7] & B_comp[i+7]) | 
                        ((A[i+7] ^ B_comp[i+7]) & sum0_temp[7]);
            wire cout1 = (A[i+7] & B_comp[i+7]) | 
                        ((A[i+7] ^ B_comp[i+7]) & sum1_temp[7]);
            
            // Select correct carry and sum based on previous block's carry
            if (i == 0) begin
                // First block always has carry-in=1 for subtraction
                assign result[i+:8] = sum1[0];
                assign block_carry[0] = cout1;
            end else begin
                // Subsequent blocks select based on previous carry
                assign result[i+:8] = block_carry[(i/8)-1] ? sum1[i/8] : sum0[i/8];
                assign block_carry[i/8] = block_carry[(i/8)-1] ? cout1 : cout0;
            end
        end
    endgenerate

    // Early overflow detection using MSB block's carry and sign bits
    wire actual_cout = block_carry[7];
    wire expected_cout = (A[63] & ~B[63]) | // Both positive case
                        ((A[63] ^ ~B[63]) & result[63]); // Mixed signs case
    
    assign overflow = (actual_cout != expected_cout);

    /* Overflow Explanation:
     * Overflow occurs when the actual carry-out doesn't match what we expect:
     * - For A positive and B negative (A-B should be positive), 
     *   if result is negative (carry-out wrong)
     * - For A negative and B positive (A-B should be negative),
     *   if result is positive (carry-out wrong)
     */
endmodule