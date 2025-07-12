module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Directly calculate the sum of A, B, and Cin
    wire [4:0] sum_with_cin;
    assign sum_with_cin = A + B + Cin;

    // Generate carry-out based on the sum
    assign Cout = (sum_with_cin > 4'd9) ? 1'b1 : 1'b0;

    // Calculate the final sum with BCD correction
    assign Sum = (sum_with_cin > 4'd9) ? sum_with_cin[3:0] + 4'd6 : sum_with_cin[3:0];

endmodule