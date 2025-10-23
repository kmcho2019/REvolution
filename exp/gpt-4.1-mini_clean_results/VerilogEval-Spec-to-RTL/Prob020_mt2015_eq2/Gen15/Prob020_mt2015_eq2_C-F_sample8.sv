module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Output 'z' is high when 2-bit inputs A and B are equal.
assign z = (A == B);

endmodule