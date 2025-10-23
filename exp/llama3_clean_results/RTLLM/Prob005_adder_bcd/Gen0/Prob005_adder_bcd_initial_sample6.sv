module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output Cout      // Carry-out output
);

// Internal signals for binary sum and carry
wire [3:0] binary_sum;
wire carry;

// Perform binary addition
assign binary_sum = A + B + Cin;

// Check if the binary sum exceeds 9
assign carry = (binary_sum > 4'd9)? 1'b1 : 1'b0;

// Apply BCD correction if sum exceeds 9
assign Sum = (carry == 1'b1)? binary_sum + 4'd6 : binary_sum;

// Generate carry-out
assign Cout = carry;

endmodule