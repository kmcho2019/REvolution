module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // First, perform binary addition of A, B, and Cin
    wire [4:0] temp_sum;
    assign temp_sum = A + B + Cin;

    // Determine if correction is needed (sum exceeds 9)
    wire correction_needed;
    assign correction_needed = (temp_sum > 4'd9) ? 1'b1 : 1'b0;

    // Generate carry-out (Cout) based on whether correction is needed
    assign Cout = correction_needed;

    // Apply correction if needed
    wire [3:0] corrected_sum;
    assign corrected_sum = (correction_needed) ? (temp_sum[3:0] + 4'd6) : temp_sum[3:0];

    // Final sum after correction
    assign Sum = corrected_sum;

endmodule