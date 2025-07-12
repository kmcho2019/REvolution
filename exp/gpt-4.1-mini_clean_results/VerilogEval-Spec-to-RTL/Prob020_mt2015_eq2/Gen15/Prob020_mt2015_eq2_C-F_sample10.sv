module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Direct 2-bit equality comparison using equality operator for clarity and efficiency
assign z = (A == B);

endmodule