module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all partial products in parallel
    wire [15:0] pp0 = B[0] ? {8'b0, A} : 16'b0;
    wire [15:0] pp1 = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    wire [15:0] pp2 = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    wire [15:0] pp3 = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    wire [15:0] pp4 = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    wire [15:0] pp5 = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    wire [15:0] pp6 = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    wire [15:0] pp7 = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // First stage of addition (parallel adders)
    wire [15:0] sum_stage1_0 = pp0 + pp1;
    wire [15:0] sum_stage1_1 = pp2 + pp3;
    wire [15:0] sum_stage1_2 = pp4 + pp5;
    wire [15:0] sum_stage1_3 = pp6 + pp7;

    // Second stage of addition
    wire [15:0] sum_stage2_0 = sum_stage1_0 + sum_stage1_1;
    wire [15:0] sum_stage2_1 = sum_stage1_2 + sum_stage1_3;

    // Final addition with carry-select optimization
    // Split into upper and lower halves for better timing
    wire [7:0] lower_sum = sum_stage2_0[7:0] + sum_stage2_1[7:0];
    wire upper_cin = (sum_stage2_0[7:0] + sum_stage2_1[7:0]) > 255;
    
    wire [7:0] upper_sum0 = sum_stage2_0[15:8] + sum_stage2_1[15:8];
    wire [7:0] upper_sum1 = upper_sum0 + 8'd1;
    
    assign product = {upper_cin ? upper_sum1 : upper_sum0, lower_sum};

endmodule