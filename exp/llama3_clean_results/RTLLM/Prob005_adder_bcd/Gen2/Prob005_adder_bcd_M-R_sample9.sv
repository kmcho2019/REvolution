module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum;
    assign binary_sum = A + B + Cin;

    // Determine the final sum and carry-out directly
    assign Sum = (binary_sum > 4'd9) ? binary_sum[3:0] + 4'd6 : binary_sum[3:0];
    assign Cout = (binary_sum > 4'd9) ? 1'b1 : binary_sum[4];

endmodule