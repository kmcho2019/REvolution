module adder_bcd(
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] Sum,
    output wire       Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_binary;
    assign sum_binary = A + B + Cin;

    // Check if the sum exceeds 9 (BCD correction needed)
    wire [3:0] sum_corrected;
    assign sum_corrected = (sum_binary > 9) ? (sum_binary + 6) : sum_binary[3:0];

    // Assign the corrected sum to the output
    assign Sum = sum_corrected;

    // Generate carry-out if the sum exceeds 9
    assign Cout = (sum_binary > 9) ? 1'b1 : ((sum_binary + 6) > 9) ? 1'b1 : 1'b0;

endmodule