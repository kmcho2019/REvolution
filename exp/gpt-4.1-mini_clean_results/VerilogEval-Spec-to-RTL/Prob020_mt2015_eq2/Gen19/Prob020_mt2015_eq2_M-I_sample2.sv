module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

assign z = &( ~(A ^ B) ); // Equivalent to XNOR across bits and AND reduction

endmodule