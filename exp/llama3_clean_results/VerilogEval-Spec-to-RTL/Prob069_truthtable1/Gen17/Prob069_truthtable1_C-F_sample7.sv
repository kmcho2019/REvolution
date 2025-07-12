module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Directly compute the output based on the simplified expression derived from Karnaugh map reduction
assign f = (x2 & ~x3) | (x1 & x3);

endmodule