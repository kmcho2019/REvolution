module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction;

    // 5-bit addition of inputs plus carry-in
    assign raw_sum = A + B + Cin;

    // Correction needed if sum > 9:
    // sum[4] == 1 means sum > 15 (always > 9)
    // or (sum[3] & (sum[2] | sum[1])) means sum between 10 and 15
    assign correction = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Add 6 if correction needed
    assign {Cout, Sum} = raw_sum + (correction ? 5'd6 : 5'd0);

endmodule