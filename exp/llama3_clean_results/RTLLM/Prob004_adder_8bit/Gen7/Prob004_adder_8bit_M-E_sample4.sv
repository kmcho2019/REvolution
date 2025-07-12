module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Internal signals for staged addition
wire [1:0] sum_stage1, sum_stage2, sum_stage3, sum_stage4;
wire c_stage1, c_stage2, c_stage3, c_stage4;

// Stage 1: Add bits 0 and 1
full_adder fa_stage1(
    .a(a[0]),
    .b(b[0]),
    .cin(cin),
    .sum(sum_stage1[0]),
    .cout(c_stage1)
);

full_adder fa_stage1_1(
    .a(a[1]),
    .b(b[1]),
    .cin(c_stage1),
    .sum(sum_stage1[1]),
    .cout(c_stage2)
);

// Stage 2: Add bits 2 and 3
full_adder fa_stage2(
    .a(a[2]),
    .b(b[2]),
    .cin(c_stage2),
    .sum(sum_stage2[0]),
    .cout(c_stage3)
);

full_adder fa_stage2_1(
    .a(a[3]),
    .b(b[3]),
    .cin(c_stage3),
    .sum(sum_stage2[1]),
    .cout(c_stage4)
);

// Stage 3: Add bits 4 and 5
full_adder fa_stage3(
    .a(a[4]),
    .b(b[4]),
    .cin(c_stage4),
    .sum(sum_stage3[0]),
    .cout(c_stage4)
);

full_adder fa_stage3_1(
    .a(a[5]),
    .b(b[5]),
    .cin(c_stage4),
    .sum(sum_stage3[1]),
    .cout(c_stage4)
);

// Stage 4: Add bits 6 and 7
full_adder fa_stage4(
    .a(a[6]),
    .b(b[6]),
    .cin(c_stage4),
    .sum(sum_stage4[0]),
    .cout(cout)
);

full_adder fa_stage4_1(
    .a(a[7]),
    .b(b[7]),
    .cin(c_stage4),
    .sum(sum_stage4[1]),
    .cout(cout)
);

// Combine the sums
assign sum[1:0] = sum_stage1;
assign sum[3:2] = sum_stage2;
assign sum[5:4] = sum_stage3;
assign sum[7:6] = sum_stage4;

endmodule

module full_adder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule