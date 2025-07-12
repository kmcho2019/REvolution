module TreeNode(
    input  [24:0] in0,
    input  [24:0] in1,
    output and_out,
    output or_out,
    output xor_out
);

    assign and_out = &{in0, in1};
    assign or_out = |{in0, in1};
    assign xor_out = ^{in0, in1};

endmodule

module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Level 1
    wire [3:0] and_l1;
    wire [3:0] or_l1;
    wire [3:0] xor_l1;

    TreeNode node0_l1(.in0(in[24:0]), .in1(in[49:25]), .and_out(and_l1[0]), .or_out(or_l1[0]), .xor_out(xor_l1[0]));
    TreeNode node1_l1(.in0(in[74:50]), .in1(in[99:75]), .and_out(and_l1[1]), .or_out(or_l1[1]), .xor_out(xor_l1[1]));

    // Level 2
    wire [1:0] and_l2;
    wire [1:0] or_l2;
    wire [1:0] xor_l2;

    TreeNode node0_l2(.in0(25'b0, and_l1[0]), .in1(25'b0, and_l1[1]), .and_out(and_l2[0]), .or_out(or_l2[0]), .xor_out(xor_l2[0]));
    TreeNode node1_l2(.in0(25'b0, or_l1[0]), .in1(25'b0, or_l1[1]), .and_out(), .or_out(or_l2[1]), .xor_out());
    TreeNode node2_l2(.in0(25'b0, xor_l1[0]), .in1(25'b0, xor_l1[1]), .and_out(), .or_out(), .xor_out(xor_l2[1]));

    // Level 3
    wire [0:0] and_l3;
    wire [0:0] or_l3;
    wire [0:0] xor_l3;

    TreeNode node0_l3(.in0(25'b0, and_l2[0]), .in1(25'b0, and_l2[0]), .and_out(and_l3[0]), .or_out(), .xor_out());
    TreeNode node1_l3(.in0(25'b0, or_l2[0]), .in1(25'b0, or_l2[1]), .and_out(), .or_out(or_l3[0]), .xor_out());
    TreeNode node2_l3(.in0(25'b0, xor_l2[0]), .in1(25'b0, xor_l2[1]), .and_out(), .or_out(), .xor_out(xor_l3[0]));

    // Final level
    assign out_and = &{25'b0, and_l3[0]};
    assign out_or = |{25'b0, or_l3[0]};
    assign out_xor = ^{25'b0, xor_l3[0]};

endmodule