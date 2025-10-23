module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Partial product generation
    wire [15:0] pp0 = B[0] ? {8'b0, A} : 16'b0;
    wire [15:0] pp1 = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    wire [15:0] pp2 = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    wire [15:0] pp3 = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    wire [15:0] pp4 = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    wire [15:0] pp5 = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    wire [15:0] pp6 = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    wire [15:0] pp7 = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // First level of Wallace tree (3:2 compressors)
    wire [15:0] sum1, carry1;
    assign sum1 = pp0 ^ pp1 ^ pp2;
    assign carry1 = ((pp0 & pp1) | (pp0 & pp2) | (pp1 & pp2)) << 1;

    wire [15:0] sum2, carry2;
    assign sum2 = pp3 ^ pp4 ^ pp5;
    assign carry2 = ((pp3 & pp4) | (pp3 & pp5) | (pp4 & pp5)) << 1;

    // Second level of Wallace tree
    wire [15:0] sum3, carry3;
    assign sum3 = sum1 ^ sum2 ^ carry1;
    assign carry3 = ((sum1 & sum2) | (sum1 & carry1) | (sum2 & carry1)) << 1;

    wire [15:0] sum4, carry4;
    assign sum4 = pp6 ^ pp7 ^ carry2;
    assign carry4 = ((pp6 & pp7) | (pp6 & carry2) | (pp7 & carry2)) << 1;

    // Final reduction
    wire [15:0] sum5, carry5;
    assign sum5 = sum3 ^ sum4 ^ carry3;
    assign carry5 = ((sum3 & sum4) | (sum3 & carry3) | (sum4 & carry3)) << 1;

    // Final addition (ripple carry for simplicity)
    wire [15:0] final_sum = sum5 + carry4 + carry5;

    assign product = final_sum;

endmodule