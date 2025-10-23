module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // Check if the binary sum exceeds 9 (1001 in binary)
    wire exceed_9 = (bin_sum > 4'd9);

    // Apply BCD correction if sum exceeds 9
    wire [4:0] corrected_sum = exceed_9 ? bin_sum + 6 : bin_sum;

    // Assign the 4 least significant bits of corrected_sum to Sum
    assign Sum = corrected_sum[3:0];

    // Generate carry-out if corrected_sum exceeds 4 (since BCD range is 0-9)
    assign Cout = corrected_sum[4];

endmodule