module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Intermediate variable to hold the binary sum
wire [4:0] binary_sum;

// Perform binary addition
assign binary_sum = {1'b0, A} + {1'b0, B} + {3'b0, Cin};

// Determine if a carry-out is needed
assign Cout = (binary_sum > 9) ? 1'b1 : 1'b0;

// Apply BCD correction if sum exceeds 9
assign Sum = (binary_sum > 9) ? binary_sum[3:0] + 4'd6 : binary_sum[3:0];

endmodule