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

    // Step 1: 5-bit binary addition of inputs plus carry-in
    assign raw_sum = A + B + Cin;

    // Step 2: Efficient correction detection using minimal logic
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Conditionally add 6 (binary 0110) if correction is needed
    assign corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    // Step 4: Output is lower 4 bits of corrected sum; Cout is correction indicator
    assign Sum  = corrected_sum[3:0];
    assign Cout = correction_needed;

endmodule