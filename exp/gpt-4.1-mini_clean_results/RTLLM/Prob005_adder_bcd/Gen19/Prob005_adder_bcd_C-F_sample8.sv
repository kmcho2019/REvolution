module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction;

    // Step 1: Add inputs with carry-in (5-bit sum)
    assign raw_sum = A + B + Cin;

    // Step 2: Efficient correction detection (sum > 9)
    // Correction needed if raw_sum > 9:
    // raw_sum[4] == 1 means sum >= 16 (>9)
    // or (raw_sum[3] & (raw_sum[2] | raw_sum[1])) means 10-15 range
    assign correction = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Add correction (6) if needed, producing corrected sum and carry-out
    assign {Cout, Sum} = raw_sum + (correction ? 5'd6 : 5'd0);

endmodule