module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all partial products directly
    wire [15:0] pp0 = {{8{1'b0}}, (A & {8{B[0]}})} << 0;
    wire [15:0] pp1 = {{8{1'b0}}, (A & {8{B[1]}})} << 1;
    wire [15:0] pp2 = {{8{1'b0}}, (A & {8{B[2]}})} << 2;
    wire [15:0] pp3 = {{8{1'b0}}, (A & {8{B[3]}})} << 3;
    wire [15:0] pp4 = {{8{1'b0}}, (A & {8{B[4]}})} << 4;
    wire [15:0] pp5 = {{8{1'b0}}, (A & {8{B[5]}})} << 5;
    wire [15:0] pp6 = {{8{1'b0}}, (A & {8{B[6]}})} << 6;
    wire [15:0] pp7 = {{8{1'b0}}, (A & {8{B[7]}})} << 7;

    // First reduction stage (4:2)
    wire [15:0] sum1 = pp0 ^ pp1 ^ pp2 ^ pp3;
    wire [15:0] c1 = ((pp0 & pp1) | (pp0 & pp2) | (pp0 & pp3) | 
                     (pp1 & pp2) | (pp1 & pp3) | 
                     (pp2 & pp3));
    
    // Second reduction stage (3:2)
    wire [15:0] sum2 = sum1 ^ {c1[14:0], 1'b0} ^ pp4;
    wire [15:0] c2 = (sum1 & {c1[14:0], 1'b0}) | 
                     (sum1 & pp4) | 
                     ({c1[14:0], 1'b0} & pp4);

    // Third reduction stage (3:2)
    wire [15:0] sum3 = sum2 ^ {c2[14:0], 1'b0} ^ pp5;
    wire [15:0] c3 = (sum2 & {c2[14:0], 1'b0}) | 
                     (sum2 & pp5) | 
                     ({c2[14:0], 1'b0} & pp5);

    // Final addition (ripple carry)
    wire [15:0] final_op = pp6 + pp7 + {c3[14:0], 1'b0};
    assign product = sum3 + final_op;

endmodule