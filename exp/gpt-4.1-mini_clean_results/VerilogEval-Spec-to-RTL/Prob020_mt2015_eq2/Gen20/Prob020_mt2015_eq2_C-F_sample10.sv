module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Explicit bitwise equality: bitwise XNOR followed by AND reduction
assign z = & ~(A ^ B);

endmodule