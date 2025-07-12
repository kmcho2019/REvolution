module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Internal wires for binary sum and carry
wire [3:0] bin_sum;
wire bin_carry;

// Binary addition of A, B, and Cin
assign bin_sum = A + B + Cin;

// Check if the binary sum exceeds 9 (BCD range)
assign Cout = (bin_sum > 4'd9) ? 1'b1 : 1'b0;

// Apply BCD correction if the sum exceeds 9
assign Sum = (bin_sum > 4'd9) ? (bin_sum + 4'd6) : bin_sum;

endmodule