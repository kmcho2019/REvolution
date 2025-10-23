module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// The original expression is already efficient and simple.
// We keep it as is, considering the synthesis tool will optimize it further.
assign f = (x2 & ~x3) | (x1 & x3);

endmodule