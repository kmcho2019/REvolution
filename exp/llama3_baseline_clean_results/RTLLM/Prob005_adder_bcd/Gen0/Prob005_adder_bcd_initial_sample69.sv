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

    // Apply BCD correction if the sum exceeds 9
    wire [4:0] corrected_sum;
    wire carry_out;
    assign corrected_sum = (binary_sum > 4'd9)? binary_sum + 5'd6 : binary_sum;
    assign carry_out = (corrected_sum > 4'd9)? 1'b1 : 1'b0;

    // Assign the corrected sum (lower 4 bits) to the output Sum
    assign Sum = corrected_sum[3:0];

    // Assign the carry-out to the output Cout
    assign Cout = carry_out;

endmodule