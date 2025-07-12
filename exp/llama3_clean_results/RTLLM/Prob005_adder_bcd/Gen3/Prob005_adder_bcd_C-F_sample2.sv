module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // Determine if correction is needed (sum exceeds 9)
    wire correction_needed = (bin_sum > 4'd9) ? 1'b1 : 1'b0;

    // Calculate Sum with correction if needed
    assign Sum = (correction_needed) ? (bin_sum[3:0] + 4'd6) : bin_sum[3:0];

    // Generate carry-out (Cout) based on whether correction is needed or if there's a carry bit
    assign Cout = (bin_sum > 4'd9) || bin_sum[4];

endmodule