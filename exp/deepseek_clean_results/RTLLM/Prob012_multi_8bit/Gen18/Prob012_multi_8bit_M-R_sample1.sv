module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all partial products with shifted versions
    wire [15:0] pp0 = {8'b0, A & {8{B[0]}}};
    wire [15:0] pp1 = {7'b0, A & {8{B[1]}}, 1'b0};
    wire [15:0] pp2 = {6'b0, A & {8{B[2]}}, 2'b0};
    wire [15:0] pp3 = {5'b0, A & {8{B[3]}}, 3'b0};
    wire [15:0] pp4 = {4'b0, A & {8{B[4]}}, 4'b0};
    wire [15:0] pp5 = {3'b0, A & {8{B[5]}}, 5'b0};
    wire [15:0] pp6 = {2'b0, A & {8{B[6]}}, 6'b0};
    wire [15:0] pp7 = {1'b0, A & {8{B[7]}}, 7'b0};

    // First level CSA reduction (8 to 6)
    wire [15:0] sum1_0 = pp0 ^ pp1 ^ pp2;
    wire [15:0] carry1_0 = ((pp0 & pp1) | (pp0 & pp2) | (pp1 & pp2)) << 1;
    
    wire [15:0] sum1_1 = pp3 ^ pp4 ^ pp5;
    wire [15:0] carry1_1 = ((pp3 & pp4) | (pp3 & pp5) | (pp4 & pp5)) << 1;
    
    wire [15:0] sum1_2 = pp6 ^ pp7;
    wire [15:0] carry1_2 = (pp6 & pp7) << 1;

    // Second level CSA reduction (6 to 4)
    wire [15:0] sum2_0 = sum1_0 ^ carry1_0 ^ sum1_1;
    wire [15:0] carry2_0 = ((sum1_0 & carry1_0) | (sum1_0 & sum1_1) | (carry1_0 & sum1_1)) << 1;
    
    wire [15:0] sum2_1 = carry1_1 ^ sum1_2 ^ carry1_2;
    wire [15:0] carry2_1 = ((carry1_1 & sum1_2) | (carry1_1 & carry1_2) | (sum1_2 & carry1_2)) << 1;

    // Third level CSA reduction (4 to 2)
    wire [15:0] sum3 = sum2_0 ^ carry2_0 ^ sum2_1;
    wire [15:0] carry3 = ((sum2_0 & carry2_0) | (sum2_0 & sum2_1) | (carry2_0 & sum2_1)) << 1;
    
    wire [15:0] sum4 = carry2_1;
    wire [15:0] carry4 = 16'b0;

    // Final addition
    assign product = sum3 + carry3 + sum4 + carry4;

endmodule