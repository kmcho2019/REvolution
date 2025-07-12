module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

assign z = &(~(A ^ B)); // Reduction AND of bitwise XNOR: all bits equal

endmodule