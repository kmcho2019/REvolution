module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] sum5;
    wire       carry_out;
    wire [4:0] corrected_sum;

    // 5-bit binary addition of inputs plus carry-in
    assign sum5 = A + B + Cin;

    // Generate carry_out (correction needed) if sum > 9 using boolean condition:
    // sum > 9 if sum[4] is 1 (sum >= 16) or (sum[3] & (sum[2] | sum[1]))
    assign carry_out = sum5[4] | (sum5[3] & (sum5[2] | sum5[1]));

    // Add 6 (0110) to correct BCD sum if carry_out is set
    assign corrected_sum = sum5 + (carry_out ? 5'd6 : 5'd0);

    // Assign output sum and carry
    assign Sum  = corrected_sum[3:0];
    assign Cout = carry_out;

endmodule