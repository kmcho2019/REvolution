module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Directly use inverted inputs in the expression without separate wires
assign out = ((~d) & (~a)) | ((~c) & (~b)) | (c & d & (a | b));

endmodule