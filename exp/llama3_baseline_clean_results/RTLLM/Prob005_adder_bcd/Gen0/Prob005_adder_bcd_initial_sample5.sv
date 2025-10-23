module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition
    wire [4:0] binary_sum;
    assign binary_sum = A + B + Cin;

    // Check if the binary sum exceeds 9 (1001 in binary)
    // If it does, add 6 (0110 in binary) for BCD correction
    wire [4:0] bcd_sum;
    assign bcd_sum = binary_sum > 9? binary_sum + 6 : binary_sum;

    // Assign the result after correction to the output Sum
    // Since Sum is 4 bits, the MSB of bcd_sum (which represents the carry) is discarded
    assign Sum = bcd_sum[3:0];

    // Generate Cout based on whether the corrected sum exceeds 9
    assign Cout = bcd_sum[4];

endmodule