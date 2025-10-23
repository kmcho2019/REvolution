module TopModule(
    input  a,
    input  b,
    output out
);

assign out = (a == b) ? 1'b1 : 1'b0;

// Alternatively, you can use the XOR operator and logical NOT
// assign out = !(a ^ b);

endmodule