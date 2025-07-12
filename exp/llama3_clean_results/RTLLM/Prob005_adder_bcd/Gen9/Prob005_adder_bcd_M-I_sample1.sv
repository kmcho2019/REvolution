module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Directly calculate the binary sum including carry-in
wire [4:0] binary_sum = {1'b0, A} + {1'b0, B} + {3'b000, Cin};

// Generate carry-out based on the binary sum exceeding 9 or having a carry bit
assign Cout = binary_sum[4];

// For the sum, if carry-out is generated, add 6 to the lower 4 bits of the binary sum
assign Sum = (Cout) ? (binary_sum[3:0] + 4'd6) : binary_sum[3:0];

endmodule