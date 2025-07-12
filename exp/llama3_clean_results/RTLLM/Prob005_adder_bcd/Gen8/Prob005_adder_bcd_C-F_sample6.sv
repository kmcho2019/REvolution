module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum = {1'b0, A} + {1'b0, B} + {3'b0, Cin};

    // Generate carry-out if the binary sum exceeds 9
    assign Cout = (binary_sum > 5'd9) || ((binary_sum <= 5'd9) && (binary_sum + 5'd6 > 5'd9));

    // Apply BCD correction if the sum exceeds 9
    assign Sum = (binary_sum > 5'd9) ? binary_sum[3:0] + 4'd6 : binary_sum[3:0];

endmodule