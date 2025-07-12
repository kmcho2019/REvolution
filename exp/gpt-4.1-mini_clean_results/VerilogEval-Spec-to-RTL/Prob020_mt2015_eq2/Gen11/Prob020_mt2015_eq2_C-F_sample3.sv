module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

assign z = &(~^(A ^ B)); // bitwise XNOR for equality, AND reduction over 2 bits

endmodule