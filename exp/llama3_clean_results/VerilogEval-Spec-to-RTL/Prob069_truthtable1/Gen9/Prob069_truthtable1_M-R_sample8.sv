module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Use the ternary operator to conditionally assign the value of f
assign f = (x2 &&!x3) || (x1 && x3)? 1'b1 : 1'b0;

endmodule