module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Output z is high if and only if A equals B
assign z = (A == B);

endmodule