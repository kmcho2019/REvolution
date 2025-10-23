module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

// Directly compare A and B, and assign the result to z
assign z = (A == B) ? 1'b1 : 1'b0;

endmodule