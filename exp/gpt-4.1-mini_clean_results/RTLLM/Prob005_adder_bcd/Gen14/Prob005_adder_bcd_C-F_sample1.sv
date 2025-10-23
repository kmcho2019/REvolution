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

    // Step 1: 4-bit binary addition with carry in, 5-bit to hold carry out
    assign raw_sum = A + B + Cin;

    // Step 2: BCD overflow detection using minimal gate expression
    // Overflow occurs if raw_sum > 9 (1001):
    // i.e. if carry-out (bit 4) is set OR (bit3 AND (bit2 OR bit1))
    assign overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Conditional addition of 6 (0110) to correct BCD if overflow
    assign corrected_sum = raw_sum + (overflow ? 5'd6 : 5'd0);

    // Outputs: lower 4 bits are BCD sum, MSB is carry out indicating overflow beyond 9
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule