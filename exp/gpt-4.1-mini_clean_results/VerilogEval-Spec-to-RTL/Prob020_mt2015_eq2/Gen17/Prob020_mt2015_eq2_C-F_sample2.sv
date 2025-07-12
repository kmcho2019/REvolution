module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// z = 1 if and only if A equals B.
// This is logically equivalent to (A == B).
// Implementation uses bitwise XOR and reduction OR to infer minimal comparator logic.
assign z = ~( | (A ^ B) );

endmodule