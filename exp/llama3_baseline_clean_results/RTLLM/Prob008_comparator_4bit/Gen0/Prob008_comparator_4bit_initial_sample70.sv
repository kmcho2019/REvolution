module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform bit-by-bit subtraction and generate borrow (carry) for each bit position
wire [3:0] result;
wire borrow_out;

// Since Verilog doesn't support direct subtraction with borrow, 
// we'll use a full adder approach or compare bits directly considering the borrow

assign result[0] = A[0] ^ B[0]; // XOR for equality check
assign borrow_out = A[0] && !B[0]; // Borrow if A is less than B at this bit

// For higher bits, we need to consider the borrow from the previous bit
assign result[1] = A[1] ^ B[1] ^ borrow_out;
assign borrow_out = (A[1] && !B[1]) || (borrow_out && (A[1] ^ B[1]));

assign result[2] = A[2] ^ B[2] ^ borrow_out;
assign borrow_out = (A[2] && !B[2]) || (borrow_out && (A[2] ^ B[2]));

assign result[3] = A[3] ^ B[3] ^ borrow_out;

// Determine outputs based on the result and borrow
assign A_greater = ~borrow_out && (result != 4'b0000);
assign A_equal = result == 4'b0000;
assign A_less = borrow_out;

endmodule