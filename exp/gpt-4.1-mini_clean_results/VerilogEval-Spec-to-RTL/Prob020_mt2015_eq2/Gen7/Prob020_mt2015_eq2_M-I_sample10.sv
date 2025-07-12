module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Use direct equality operator for optimal synthesis
assign z = (A == B);

endmodule