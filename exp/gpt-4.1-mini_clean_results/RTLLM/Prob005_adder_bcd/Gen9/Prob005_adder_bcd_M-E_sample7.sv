module ripple_carry_adder_4 (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    wire c1, c2, c3;

    assign {c1, sum[0]} = a[0] + b[0] + cin;
    assign {c2, sum[1]} = a[1] + b[1] + c1;
    assign {c3, sum[2]} = a[2] + b[2] + c2;
    assign {cout, sum[3]} = a[3] + b[3] + c3;
endmodule

module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum = A + B + Cin;  // 5-bit to hold carry out

    // Correction needed if:
    // - raw_sum > 9 (binary 1001) or
    // - carry from the 4-bit addition (raw_sum[4] == 1)
    // Check raw_sum[3:0] > 9 without magnitude comparator:
    // sum > 9 when bit3=1 and (bit2=1 or bit1=1)
    // since 9=1001, numbers >9 are 1010..1111
    wire sum_gt_9 = raw_sum[3] & (raw_sum[2] | raw_sum[1]);

    wire correction_needed = raw_sum[4] | sum_gt_9;

    wire [3:0] correction = 4'b0110; // decimal 6 for BCD correction

    // Perform correction addition only if needed
    wire [3:0] corrected_sum;
    wire       correction_cout;

    ripple_carry_adder_4 correction_adder (
        .a(raw_sum[3:0]),
        .b(correction_needed ? correction : 4'b0000),
        .cin(1'b0),
        .sum(corrected_sum),
        .cout(correction_cout)
    );

    assign Sum = corrected_sum;
    assign Cout = correction_cout;

endmodule