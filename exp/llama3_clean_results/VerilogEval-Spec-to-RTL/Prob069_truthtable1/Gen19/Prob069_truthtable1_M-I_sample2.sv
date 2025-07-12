module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Directly compute f using a simplified logical expression
assign f = x2 | (x3 & x1);

endmodule