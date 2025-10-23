module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] correction;
    wire [4:0] corrected_sum;

    // Perform 5-bit binary addition of inputs and carry-in
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Detect if correction is needed: sum > 9
    // Condition: raw_sum[4] == 1 OR (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Select correction: 6 (0110) if needed, else 0
    assign correction = correction_needed ? 5'b00110 : 5'b00000;

    // Add correction to raw_sum
    assign corrected_sum = raw_sum + correction;

    // Output sum and carry-out
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule