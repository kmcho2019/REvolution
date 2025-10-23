module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Divide the input into four 25-bit segments
    wire [24:0] seg1;
    wire [24:0] seg2;
    wire [24:0] seg3;
    wire [24:0] seg4;

    assign seg1 = in[24:0];
    assign seg2 = in[49:25];
    assign seg3 = in[74:50];
    assign seg4 = in[99:75];

    // Perform operations on each segment
    wire and_seg1, or_seg1, xor_seg1;
    wire and_seg2, or_seg2, xor_seg2;
    wire and_seg3, or_seg3, xor_seg3;
    wire and_seg4, or_seg4, xor_seg4;

    // AND operation using reduction operator
    assign and_seg1 = &seg1;
    assign and_seg2 = &seg2;
    assign and_seg3 = &seg3;
    assign and_seg4 = &seg4;

    // OR operation using reduction operator
    assign or_seg1 = |seg1;
    assign or_seg2 = |seg2;
    assign or_seg3 = |seg3;
    assign or_seg4 = |seg4;

    // XOR operation using reduction operator
    assign xor_seg1 = ^seg1;
    assign xor_seg2 = ^seg2;
    assign xor_seg3 = ^seg3;
    assign xor_seg4 = ^seg4;

    // Combine the results from each segment
    wire and_tmp1, and_tmp2;
    wire or_tmp1, or_tmp2;
    wire xor_tmp1, xor_tmp2;

    assign and_tmp1 = and_seg1 & and_seg2;
    assign and_tmp2 = and_seg3 & and_seg4;
    assign out_and = and_tmp1 & and_tmp2;

    assign or_tmp1 = or_seg1 | or_seg2;
    assign or_tmp2 = or_seg3 | or_seg4;
    assign out_or = or_tmp1 | or_tmp2;

    assign xor_tmp1 = xor_seg1 ^ xor_seg2;
    assign xor_tmp2 = xor_seg3 ^ xor_seg4;
    assign out_xor = xor_tmp1 ^ xor_tmp2;

endmodule