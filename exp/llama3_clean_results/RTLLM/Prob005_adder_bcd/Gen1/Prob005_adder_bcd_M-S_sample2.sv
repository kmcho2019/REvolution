module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output Cout      // Carry-out output
);

// Perform binary addition
wire [4:0] binary_sum = A + B + Cin;

// Apply BCD correction and generate carry-out
assign Sum = (binary_sum > 4'd9)? binary_sum + 4'd6 : binary_sum[3:0];
assign Cout = (binary_sum > 4'd9)? 1'b1 : 1'b0;

endmodule