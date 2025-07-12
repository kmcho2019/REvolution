module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_uncorrected;
    assign sum_uncorrected = A + B + Cin;

    // Check if the sum exceeds the decimal value of 9
    wire exceed_9;
    assign exceed_9 = (sum_uncorrected > 4'd9) ? 1'b1 : 1'b0;

    // Apply BCD correction if necessary
    wire [4:0] sum_corrected;
    assign sum_corrected = exceed_9 ? sum_uncorrected + 4'd6 : sum_uncorrected;

    // Generate carry-out if the sum exceeds 9
    assign Cout = (sum_corrected > 4'd9) ? 1'b1 : 1'b0;

    // Assign the corrected sum to the output, taking only the lower 4 bits
    assign Sum = sum_corrected[3:0];

endmodule