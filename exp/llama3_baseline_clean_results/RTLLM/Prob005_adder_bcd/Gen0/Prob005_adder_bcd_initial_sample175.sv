module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum;
    assign binary_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Apply BCD correction if sum exceeds 9
    wire [4:0] corrected_sum;
    assign corrected_sum = (binary_sum > 9) ? binary_sum + 6 : binary_sum;

    // Generate carry-out if result exceeds 9
    assign Cout = (corrected_sum > 9) ? 1'b1 : 1'b0;

    // Ensure the output Sum is within BCD range (0-9)
    assign Sum = corrected_sum[3:0];

endmodule