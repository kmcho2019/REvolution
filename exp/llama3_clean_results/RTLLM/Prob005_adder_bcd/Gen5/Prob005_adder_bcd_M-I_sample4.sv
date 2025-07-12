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

    // Generate carry-out directly from binary sum
    assign Cout = binary_sum[4];

    // Simplify correction logic
    wire [3:0] corrected_sum;
    assign corrected_sum = (binary_sum[4]) ? (binary_sum[3:0] + 4'd6) : binary_sum[3:0];

    assign Sum = corrected_sum;

endmodule