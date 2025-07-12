module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Step 1: Perform 5-bit binary addition of inputs and carry-in
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Determine if correction is needed (sum > 9)
    // Condition for sum > 9: raw_sum > 9 (5'd9)
    assign correction_needed = (raw_sum > 5'd9);

    // Step 3: Conditionally add 6 (5'b00110) if correction needed
    assign corrected_sum = raw_sum + (correction_needed ? 5'b00110 : 5'b00000);

    // Step 4: Outputs
    assign Sum = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule