module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all partial products directly
    wire [15:0] pp0 = B[0] ? {8'b0, A} : 16'b0;
    wire [15:0] pp1 = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    wire [15:0] pp2 = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    wire [15:0] pp3 = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    wire [15:0] pp4 = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    wire [15:0] pp5 = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    wire [15:0] pp6 = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    wire [15:0] pp7 = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // First level additions (equivalent to CSA)
    wire [15:0] sum1_0 = pp0 ^ pp1 ^ pp2;
    wire [15:0] carry1_0 = ((pp0 & pp1) | (pp0 & pp2) | (pp1 & pp2)) << 1;

    wire [15:0] sum1_1 = pp3 ^ pp4 ^ pp5;
    wire [15:0] carry1_1 = ((pp3 & pp4) | (pp3 & pp5) | (pp4 & pp5)) << 1;

    // Second level additions
    wire [15:0] sum2 = sum1_0 ^ carry1_0 ^ sum1_1;
    wire [15:0] carry2 = ((sum1_0 & carry1_0) | (sum1_0 & sum1_1) | (carry1_0 & sum1_1)) << 1;

    // Third level combines remaining terms
    wire [15:0] sum3 = sum2 ^ carry2 ^ carry1_1;
    wire [15:0] carry3 = ((sum2 & carry2) | (sum2 & carry1_1) | (carry2 & carry1_1)) << 1;

    // Final addition (all remaining terms)
    assign product = sum3 + carry3 + pp6 + pp7;

endmodule