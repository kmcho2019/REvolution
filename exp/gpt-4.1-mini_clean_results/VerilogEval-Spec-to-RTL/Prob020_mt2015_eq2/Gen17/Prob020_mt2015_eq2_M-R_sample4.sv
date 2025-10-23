module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Explicit bitwise XNOR of each bit, then reduction AND to determine equality
assign z = & ~(A ^ B);

endmodule