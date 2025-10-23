module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       overflow;
    wire [4:0] corrected_sum;

    // Add inputs and carry-in (5 bits to include carry)
    assign raw_sum = A + B + Cin;

    // Detect BCD overflow:
    // Overflow if raw_sum > 9:
    // equivalent to (raw_sum[4]) or (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Add correction (6) only if overflow, else add 0.
    // Use a single addition stage for correction by muxing correction input.
    assign corrected_sum = raw_sum + (overflow ? 5'd6 : 5'd0);

    // Final Sum and Cout from corrected sum
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule