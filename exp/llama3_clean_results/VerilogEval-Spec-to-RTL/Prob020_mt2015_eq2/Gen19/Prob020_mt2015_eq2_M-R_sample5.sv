module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);
assign z = (A == B)? 1'b1 : 1'b0;
// Alternatively, this can be simplified to:
// assign z = A == B;
endmodule