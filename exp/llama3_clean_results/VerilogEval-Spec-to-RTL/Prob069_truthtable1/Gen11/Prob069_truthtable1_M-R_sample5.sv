module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Use a basic logical expression to assign the value of f
assign f = (x2 && !x3) || (x1 && x3);

endmodule