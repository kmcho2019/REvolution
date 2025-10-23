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

    // Step 2: Detect BCD correction need (sum > 9)
    // Correction if raw_sum > 9:
    // raw_sum[4] is set if sum >= 16
    // or (raw_sum[3] & (raw_sum[2] | raw_sum[1])) covers sums from 10 to 15
    assign correction = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Conditionally add 6 to raw_sum for BCD correction
    assign {Cout, Sum} = raw_sum + (correction ? 5'd6 : 5'd0);

endmodule