module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all partial products
    wire [15:0] pp0 = B[0] ? {8'b0, A}       : 16'b0;
    wire [15:0] pp1 = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    wire [15:0] pp2 = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    wire [15:0] pp3 = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    wire [15:0] pp4 = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    wire [15:0] pp5 = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    wire [15:0] pp6 = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    wire [15:0] pp7 = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // First level of addition (4 pairs)
    wire [15:0] sum_l1_0, carry_l1_0;
    wire [15:0] sum_l1_1, carry_l1_1;
    wire [15:0] sum_l1_2, carry_l1_2;
    wire [15:0] sum_l1_3, carry_l1_3;
    
    // CSA implementation using direct assignments
    assign {carry_l1_0, sum_l1_0} = pp0 + pp1;
    assign {carry_l1_1, sum_l1_1} = pp2 + pp3;
    assign {carry_l1_2, sum_l1_2} = pp4 + pp5;
    assign {carry_l1_3, sum_l1_3} = pp6 + pp7;

    // Second level of addition (2 pairs)
    wire [15:0] sum_l2_0, carry_l2_0;
    wire [15:0] sum_l2_1, carry_l2_1;
    
    assign {carry_l2_0, sum_l2_0} = sum_l1_0 + sum_l1_1 + {carry_l1_0[14:0], 1'b0};
    assign {carry_l2_1, sum_l2_1} = sum_l1_2 + sum_l1_3 + {carry_l1_2[14:0], 1'b0};

    // Final addition
    wire [15:0] final_sum = sum_l2_0 + sum_l2_1;
    wire [15:0] final_carry = {carry_l2_0[14:0], 1'b0} + {carry_l2_1[14:0], 1'b0};
    
    // Single CLA adder for final result
    assign product = final_sum + final_carry;

endmodule