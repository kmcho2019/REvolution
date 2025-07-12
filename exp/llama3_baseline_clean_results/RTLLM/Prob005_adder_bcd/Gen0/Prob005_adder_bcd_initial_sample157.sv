module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum of A and B
    output Cout      // Carry-out output
);

    // Internal signals for the sum before and after BCD correction
    wire [4:0] sum_before_correction;
    wire [4:0] sum_after_correction;

    // Perform binary addition of A, B, and Cin
    assign sum_before_correction = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Generate a carry-out if the sum exceeds 9 (binary 1001)
    assign Cout = (sum_before_correction > 9) ? 1'b1 : 1'b0;

    // Apply BCD correction if the sum exceeds 9
    assign sum_after_correction = (sum_before_correction > 9) ? (sum_before_correction + 6) : sum_before_correction;

    // Assign the final sum to the output, ensuring it's within the BCD range
    assign Sum = sum_after_correction[3:0];

endmodule