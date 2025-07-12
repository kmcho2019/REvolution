module TopModule(
    input x,
    input y,
    output z
);

// Directly implement the boolean function z = (x^y) & x
assign z = (x ^ y) & x;

endmodule