module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Early termination for trivial cases
    wire equal = (A == B);
    wire trivial = equal || (B == 64'd0);
    
    // Two's complement inversion with early termination
    wire [63:0] B_comp = trivial ? 64'd0 : ~B;
    wire cin = trivial ? 1'b0 : 1'b1;
    
    // 8-bit slices with carry-select
    wire [7:0] carry_out;
    wire [63:0] sum;
    
    genvar i;
    generate
        for (i=0; i<64; i=i+8) begin : SLICE
            // Carry-in for this slice
            wire local_cin = (i == 0) ? cin : carry_out[(i/8)-1];
            
            // Compute both possible carry scenarios
            wire [7:0] sum0, sum1;
            wire cout0, cout1;
            
            // Case 0: carry-in = 0
            assign {cout0, sum0} = A[i+:8] + B_comp[i+:8] + 8'd0;
            
            // Case 1: carry-in = 1
            assign {cout1, sum1} = A[i+:8] + B_comp[i+:8] + 8'd1;
            
            // Select correct result based on actual carry-in
            assign carry_out[i/8] = local_cin ? cout1 : cout0;
            assign sum[i+:8] = local_cin ? sum1 : sum0;
            
            // Predictive overflow detection per slice
            if (i == 56) begin // Only needed for MSB slice
                wire sign_A = A[63];
                wire sign_B_comp = B_comp[63];
                wire predicted_sign = sum1[7]; // Use carry=1 case for prediction
                
                // Overflow occurs if:
                // 1. Signs of A and ~B differ, and result sign doesn't match A's sign
                // 2. Computed in parallel with addition
                assign overflow = trivial ? 1'b0 : 
                                ((sign_A ^ sign_B_comp) && (sign_A ^ predicted_sign));
            end
        end
    endgenerate

    // Final result selection
    assign result = equal ? 64'd0 : 
                   (B == 64'd0) ? A : 
                   sum;

endmodule