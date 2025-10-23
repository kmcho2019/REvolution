module TopModule(
    input  [1:0] A,
    input  [1:0] B,
    output z
);

// Direct comparison using the equality operator is straightforward and efficient.
assign z = (A == B)? 1'b1 : 1'b0;

endmodule