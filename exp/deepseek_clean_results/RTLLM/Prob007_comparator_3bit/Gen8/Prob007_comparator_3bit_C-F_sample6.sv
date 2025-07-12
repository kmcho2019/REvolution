module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Fast equality check (parallel bit comparison)
wire equal = (A == B);

// Efficient magnitude comparison using subtraction sign bit
wire [3:0] diff = {1'b0, A} - {1'b0, B};
wire greater = ~diff[3] & ~equal;  // Positive and not equal
wire less = diff[3];               // Negative (implies not equal)

// Output assignments
assign A_greater = greater;
assign A_equal = equal;
assign A_less = less;

// Alternative implementation showing combined benefits:
// assign A_equal = (A[2] ~^ B[2]) & (A[1] ~^ B[1]) & (A[0] ~^ B[0]);
// assign A_greater = (A[2] & ~B[2]) | 
//                   (~(A[2] ^ B[2]) & A[1] & ~B[1]) | 
//                   (~(A[2] ^ B[2]) & ~(A[1] ^ B[1]) & A[0] & ~B[0]);
// assign A_less = ~A_equal & ~A_greater;

endmodule