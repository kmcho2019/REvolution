module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B and generate borrow signal
wire [3:0] result;
wire borrow;

// Full subtractor circuit
assign result[0] = A[0] ^ B[0] ^ borrow;
assign borrow = (A[0] < B[0])? 1'b1 : 1'b0;

// Since Verilog doesn't directly support a simple subtract operation 
// for generating a borrow, we'll implement the subtraction using a 
// series of full subtractors, updating the borrow as we go.

// Corrected implementation for a 4-bit subtraction with borrow
assign result[0] = A[0] ^ B[0] ^ 1'b0; // initial subtraction
assign borrow = (A[0] < B[0])? 1'b1 : 1'b0;

wire borrow1;
assign result[1] = A[1] ^ B[1] ^ borrow;
assign borrow1 = (A[1] < B[1]) || (A[1] == B[1] && borrow)? 1'b1 : 1'b0;

wire borrow2;
assign result[2] = A[2] ^ B[2] ^ borrow1;
assign borrow2 = (A[2] < B[2]) || (A[2] == B[2] && borrow1)? 1'b1 : 1'b0;

wire borrow3;
assign result[3] = A[3] ^ B[3] ^ borrow2;
assign borrow3 = (A[3] < B[3]) || (A[3] == B[3] && borrow2)? 1'b1 : 1'b0;

// Determine outputs based on result and borrow
assign A_greater = ~borrow3 & ~(|result); // A > B if no borrow and result is not zero
assign A_equal = ~borrow3 & ~(|result); // A == B if no borrow and result is zero
assign A_less = borrow3; // A < B if borrow

// Ensure outputs are mutually exclusive
assign A_greater = A_greater & ~A_equal & ~A_less;
assign A_equal = A_equal & ~A_greater & ~A_less;
assign A_less = A_less & ~A_greater & ~A_equal;

endmodule