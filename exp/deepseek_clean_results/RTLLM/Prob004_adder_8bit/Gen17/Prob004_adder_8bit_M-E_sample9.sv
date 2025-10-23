module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    // Lower 4-bit ripple-carry section
    wire [3:0] sum_low;
    wire c3;
    
    // Bit 0
    assign sum_low[0] = a[0] ^ b[0] ^ cin;
    wire c0 = (a[0] & b[0]) | (cin & (a[0] | b[0]));
    
    // Bit 1
    assign sum_low[1] = a[1] ^ b[1] ^ c0;
    wire c1 = (a[1] & b[1]) | (c0 & (a[1] | b[1]));
    
    // Bit 2
    assign sum_low[2] = a[2] ^ b[2] ^ c1;
    wire c2 = (a[2] & b[2]) | (c1 & (a[2] | b[2]));
    
    // Bit 3
    assign sum_low[3] = a[3] ^ b[3] ^ c2;
    assign c3 = (a[3] & b[3]) | (c2 & (a[3] | b[3]));
    
    // Upper 4-bit carry-select with prediction
    wire carry_likely = (a[3:0] + b[3:0] + cin) > 15;  // Prediction
    
    // Compute both possible sums for upper bits
    wire [3:0] sum_high_c0, sum_high_c1;
    wire cout_c0, cout_c1;
    
    // Upper bits assuming carry-in 0
    assign sum_high_c0[0] = a[4] ^ b[4] ^ 1'b0;
    wire c4_0 = (a[4] & b[4]) | (1'b0 & (a[4] | b[4]));
    
    assign sum_high_c0[1] = a[5] ^ b[5] ^ c4_0;
    wire c5_0 = (a[5] & b[5]) | (c4_0 & (a[5] | b[5]));
    
    assign sum_high_c0[2] = a[6] ^ b[6] ^ c5_0;
    wire c6_0 = (a[6] & b[6]) | (c5_0 & (a[6] | b[6]));
    
    assign sum_high_c0[3] = a[7] ^ b[7] ^ c6_0;
    assign cout_c0 = (a[7] & b[7]) | (c6_0 & (a[7] | b[7]));
    
    // Upper bits assuming carry-in 1
    assign sum_high_c1[0] = a[4] ^ b[4] ^ 1'b1;
    wire c4_1 = (a[4] & b[4]) | (1'b1 & (a[4] | b[4]));
    
    assign sum_high_c1[1] = a[5] ^ b[5] ^ c4_1;
    wire c5_1 = (a[5] & b[5]) | (c4_1 & (a[5] | b[5]));
    
    assign sum_high_c1[2] = a[6] ^ b[6] ^ c5_1;
    wire c6_1 = (a[6] & b[6]) | (c5_1 & (a[6] | b[6]));
    
    assign sum_high_c1[3] = a[7] ^ b[7] ^ c6_1;
    assign cout_c1 = (a[7] & b[7]) | (c6_1 & (a[7] | b[7]));
    
    // Final selection with prediction
    wire prediction_correct = (carry_likely == c3);
    wire [3:0] sum_high_pred = carry_likely ? sum_high_c1 : sum_high_c0;
    wire cout_pred = carry_likely ? cout_c1 : cout_c0;
    
    // Correct if mispredicted (rare case)
    assign sum[7:4] = prediction_correct ? sum_high_pred : (c3 ? sum_high_c1 : sum_high_c0);
    assign cout = prediction_correct ? cout_pred : (c3 ? cout_c1 : cout_c0);
    
    // Combine results
    assign sum[3:0] = sum_low;
    
endmodule