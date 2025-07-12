module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Explicit bitwise XNOR followed by reduction AND to implement equality
assign z = & ~(A ^ B);

endmodule