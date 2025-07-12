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

    // Check if the sum exceeds 9 and perform BCD correction if necessary
    assign Sum = (binary_sum[4]) ? (binary_sum[3:0] + 4'd6) : binary_sum[3:0];
    assign Cout = binary_sum[4];

endmodule