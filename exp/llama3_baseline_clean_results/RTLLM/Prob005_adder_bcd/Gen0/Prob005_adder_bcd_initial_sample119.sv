module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_bin;
    assign sum_bin = A + B + Cin;

    // Check if the sum exceeds 9 (1001 in binary) and apply correction
    assign Sum = (sum_bin > 4'd9) ? sum_bin + 4'd6 : sum_bin[3:0];
    assign Cout = (sum_bin > 4'd9) ? 1'b1 : (sum_bin[4] != 0);

endmodule