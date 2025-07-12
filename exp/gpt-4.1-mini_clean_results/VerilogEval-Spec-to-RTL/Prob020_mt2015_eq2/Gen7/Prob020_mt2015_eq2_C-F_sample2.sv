module TopModule (
    input  [1:0] A,  // 2-bit input A
    input  [1:0] B,  // 2-bit input B
    output       z   // Output is 1 if A equals B, else 0
);

// Continuous assignment compares A and B using equality operator
assign z = (A == B);

endmodule