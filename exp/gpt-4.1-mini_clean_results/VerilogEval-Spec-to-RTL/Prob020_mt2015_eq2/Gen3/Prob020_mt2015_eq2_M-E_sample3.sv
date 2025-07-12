module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire [1:0] diff;
wire borrow0, borrow1;
wire diff_is_zero;

// Subtract B from A using bitwise subtraction with borrow
assign {borrow0, diff[0]} = {1'b0, A[0]} - B[0];
assign {borrow1, diff[1]} = {borrow0, A[1]} - B[1];

// Check if difference is zero by NORing all bits
assign diff_is_zero = ~(diff[0] | diff[1]);

// Output z is 1 if difference is zero (A == B)
assign z = diff_is_zero;

endmodule