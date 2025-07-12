module adder_bcd(
    input [3:0] A, // First BCD input
    input [3:0] B, // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum, // 4-bit output representing the BCD sum
    output Cout      // Carry-out output
);

    // Temporary wires to hold the binary sum and carry
    wire [4:0] bin_sum;
    wire [4:0] corrected_sum;

    // Perform binary addition of A, B, and Cin
    assign bin_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Check if the binary sum exceeds 9 (BCD correction needed)
    assign corrected_sum = (bin_sum > 4'd9)? bin_sum + 4'd6 : bin_sum;

    // Assign the corrected sum (lower 4 bits) to the Sum output
    assign Sum = corrected_sum[3:0];

    // Generate the carry-out (Cout) if the corrected sum exceeds 9
    assign Cout = (bin_sum > 4'd9) || (corrected_sum > 4'd9);

    // Alternatively, Cout can be directly assigned based on bin_sum
    // assign Cout = (bin_sum[4] == 1'b1);

endmodule