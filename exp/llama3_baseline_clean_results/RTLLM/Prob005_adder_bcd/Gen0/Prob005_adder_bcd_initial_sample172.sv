module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Internal wire for the binary sum
    wire [4:0] bin_sum;

    // Perform binary addition of A, B, and Cin
    assign bin_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Assign Cout (carry-out) based on the most significant bit of the binary sum
    assign Cout = bin_sum[4];

    // Assign Sum based on whether the binary sum exceeds 9
    assign Sum = (bin_sum < 5'd10) ? bin_sum[3:0] : (bin_sum + 5'd6)[3:0];

endmodule