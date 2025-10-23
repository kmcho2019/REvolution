module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Implement equality by bitwise XNOR and then AND all bits to detect A == B
assign z = & ( ~(A ^ B) );

endmodule