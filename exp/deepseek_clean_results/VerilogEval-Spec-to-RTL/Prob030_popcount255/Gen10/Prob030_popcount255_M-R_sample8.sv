module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count '1's in 3-bit chunks (85 chunks)
    wire [1:0] l1_0  = in[0]   + in[1]   + in[2];
    wire [1:0] l1_1  = in[3]   + in[4]   + in[5];
    // ... (all 85 level1 counters)
    wire [1:0] l1_84 = in[252] + in[253] + in[254];

    // Level 2: Sum 3 level1 counters (28 groups + 1 remainder)
    wire [3:0] l2_0  = l1_0  + l1_1  + l1_2;
    wire [3:0] l2_1  = l1_3  + l1_4  + l1_5;
    // ... (all 28 level2 groups)
    wire [3:0] l2_28 = l1_84;  // Last counter

    // Level 3: Sum 3 level2 counters (9 groups + 1 remainder)
    wire [5:0] l3_0 = l2_0  + l2_1  + l2_2;
    wire [5:0] l3_1 = l2_3  + l2_4  + l2_5;
    // ... (all 9 level3 groups)
    wire [5:0] l3_9 = l2_27 + l2_28;  // Last group

    // Final addition
    wire [7:0] sum_grp0 = l3_0 + l3_1 + l3_2;
    wire [7:0] sum_grp1 = l3_3 + l3_4 + l3_5;
    wire [7:0] sum_grp2 = l3_6 + l3_7 + l3_8;
    wire [7:0] sum_grp3 = l3_9;
    
    assign out = sum_grp0 + sum_grp1 + sum_grp2 + sum_grp3;

endmodule