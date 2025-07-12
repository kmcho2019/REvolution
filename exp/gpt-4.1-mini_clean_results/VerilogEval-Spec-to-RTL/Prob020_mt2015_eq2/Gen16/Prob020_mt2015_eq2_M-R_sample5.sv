module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// XOR the vectors, then use reduction OR to detect if any bits differ
assign z = ~( | (A ^ B) );

endmodule