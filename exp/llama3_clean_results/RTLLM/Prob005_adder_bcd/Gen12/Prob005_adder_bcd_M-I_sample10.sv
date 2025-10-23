module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Directly compute the binary sum of A, B, and Cin
    wire [4:0] binary_sum = {1'b0, A} + {1'b0, B} + {3'b0, Cin};

    // Check if the sum exceeds 9 (1001 in binary) and generate carry-out accordingly
    assign Cout = binary_sum[4];

    // If the sum exceeds 9, add correction of 6 (0110 in binary) to ensure BCD validity
    assign Sum = (binary_sum[4]) ? (binary_sum[3:0] + 4'd6) : binary_sum[3:0];

endmodule