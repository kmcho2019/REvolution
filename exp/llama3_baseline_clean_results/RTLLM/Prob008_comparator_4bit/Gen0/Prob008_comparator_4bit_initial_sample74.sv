module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal wires for subtraction result and borrow
wire [3:0] diff;
wire borrow;

// Perform subtraction A - B
assign diff[0] = A[0] ^ B[0] ^ borrow;
assign diff[1] = A[1] ^ B[1] ^ borrow;
assign diff[2] = A[2] ^ B[2] ^ borrow;
assign diff[3] = A[3] ^ B[3] ^ borrow;

// Borrow generation
assign borrow = (~A[0] & B[0]) | ((~A[0] & ~B[0]) & borrow) | (A[0] & B[0] & borrow);

// Corrected borrow generation using a more standard approach
// This example uses a ripple borrow approach which isn't ideal for all scenarios
// but illustrates the concept. For a more accurate representation, consider
// using a carry-lookahead or a more sophisticated borrow generation method.

// Correct implementation should consider each bit position's borrow individually
// and propagate it to the next. However, due to the simplicity of the task and
// focusing on the comparator's logic, we'll simplify this step.

// A more proper way to generate borrow for each bit position
wire borrow0, borrow1, borrow2, borrow3;
assign diff[0] = A[0] ^ B[0];
assign borrow0 = ~A[0] & B[0];
assign diff[1] = A[1] ^ B[1] ^ borrow0;
assign borrow1 = (~A[1] & B[1]) | (~A[1] & ~B[1] & borrow0) | (A[1] & B[1] & borrow0);
assign diff[2] = A[2] ^ B[2] ^ borrow1;
assign borrow2 = (~A[2] & B[2]) | (~A[2] & ~B[2] & borrow1) | (A[2] & B[2] & borrow1);
assign diff[3] = A[3] ^ B[3] ^ borrow2;
assign borrow3 = (~A[3] & B[3]) | (~A[3] & ~B[3] & borrow2) | (A[3] & B[3] & borrow2);

// Determine outputs based on the result and borrow
assign A_greater = ~borrow3 & ~(diff[3] == 1'bx) & |diff; // A is greater if no borrow and diff is not zero
assign A_equal = ~borrow3 & ~(diff[3] == 1'bx) & ~|diff; // A is equal if no borrow and diff is zero
assign A_less = borrow3; // A is less if borrow

endmodule