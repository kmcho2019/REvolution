module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum;
    assign binary_sum = {1'b0, A} + {1'b0, B} + {3'b0, Cin};

    // Directly calculate the final sum and carry-out
    assign Cout = (binary_sum > 5'd9) ? 1'b1 : 1'b0;
    assign Sum = (binary_sum > 5'd9) ? binary_sum[3:0] + 4'd6 : binary_sum[3:0];

endmodule