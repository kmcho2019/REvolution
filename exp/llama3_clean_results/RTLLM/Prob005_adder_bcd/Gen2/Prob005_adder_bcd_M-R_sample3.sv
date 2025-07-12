module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] temp_sum;
    assign temp_sum = A + B + Cin;

    // Directly calculate the carry-out
    assign Cout = (temp_sum > 4'd9) ? 1'b1 : 1'b0;

    // Apply correction and calculate the final sum directly
    assign Sum = (temp_sum > 4'd9) ? (temp_sum + 4'd6)[3:0] : temp_sum[3:0];

endmodule