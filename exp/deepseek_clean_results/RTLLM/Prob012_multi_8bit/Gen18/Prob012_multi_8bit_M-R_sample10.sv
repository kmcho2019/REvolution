module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all partial products in one step
    wire [15:0] pp0 = {8'b0, (A & {8{B[0]}});
    wire [15:0] pp1 = {7'b0, (A & {8{B[1]}}), 1'b0};
    wire [15:0] pp2 = {6'b0, (A & {8{B[2]}}), 2'b0};
    wire [15:0] pp3 = {5'b0, (A & {8{B[3]}}), 3'b0};
    wire [15:0] pp4 = {4'b0, (A & {8{B[4]}}), 4'b0};
    wire [15:0] pp5 = {3'b0, (A & {8{B[5]}}), 5'b0};
    wire [15:0] pp6 = {2'b0, (A & {8{B[6]}}), 6'b0};
    wire [15:0] pp7 = {1'b0, (A & {8{B[7]}}), 7'b0};

    // First reduction stage (4:2 compressor equivalent)
    wire [15:0] sum1 = pp0 ^ pp1 ^ pp2 ^ pp3;
    wire [15:0] carry1 = ((pp0 & pp1) | (pp0 & pp2) | (pp1 & pp2)) ^ 
                        ((pp0 ^ pp1 ^ pp2) & pp3);

    // Second reduction stage (3:2 CSA equivalent)
    wire [15:0] sum2 = sum1 ^ {carry1[14:0], 1'b0} ^ pp4;
    wire [15:0] carry2 = (sum1 & {carry1[14:0], 1'b0}) | 
                        (sum1 & pp4) | 
                        ({carry1[14:0], 1'b0} & pp4);

    // Third reduction stage
    wire [15:0] sum3 = sum2 ^ {carry2[14:0], 1'b0} ^ pp5;
    wire [15:0] carry3 = (sum2 & {carry2[14:0], 1'b0}) | 
                        (sum2 & pp5) | 
                        ({carry2[14:0], 1'b0} & pp5);

    // Final addition (CLA equivalent)
    wire [15:0] final_op = pp6 + pp7 + {carry3[14:0], 1'b0};
    assign product = sum3 + final_op;

endmodule