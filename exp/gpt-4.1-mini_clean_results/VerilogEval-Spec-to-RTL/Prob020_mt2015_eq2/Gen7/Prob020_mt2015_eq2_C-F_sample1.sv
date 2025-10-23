module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire xnor0, xnor1;

// Explicit bitwise comparison using XNOR gates
xnor u_xnor0 (xnor0, A[0], B[0]);
xnor u_xnor1 (xnor1, A[1], B[1]);

// Final output assigned via built-in equality operator for synthesis efficiency
assign z = (A == B);

endmodule