module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum = A + B + Cin;

    // Extract the lower 4 bits (binary sum without carry)
    wire [3:0] lower_sum = binary_sum[3:0];

    // Check if the lower sum is greater than 9
    wire sum_exceeds_9 = (lower_sum > 4'd9);

    // Calculate the BCD correction
    wire [3:0] bcd_correction = sum_exceeds_9? 4'd6 : 4'd0;

    // Apply the BCD correction to the lower sum
    wire [3:0] corrected_sum = lower_sum + bcd_correction;

    // Generate the carry-out signal
    assign Cout = binary_sum[4] | sum_exceeds_9;

    // Assign the final sum
    assign Sum = corrected_sum;

endmodule