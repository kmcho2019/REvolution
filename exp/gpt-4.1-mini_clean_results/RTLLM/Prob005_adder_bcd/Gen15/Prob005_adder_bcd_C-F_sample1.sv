module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Step 1: 5-bit addition of inputs plus carry-in
    assign raw_sum = A + B + Cin;

    // Step 2: Detect if raw_sum > 9 (BCD invalid)
    assign correction_needed = (raw_sum > 5'd9);

    // Step 3: Add correction 6 (0110) if needed to get corrected BCD sum
    assign corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    // Step 4: Output sum is lower 4 bits of corrected sum; Cout is correction indicator
    assign Sum  = corrected_sum[3:0];
    assign Cout = correction_needed;

endmodule