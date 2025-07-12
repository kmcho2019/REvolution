module TopModule(
    input x,
    input y,
    output z
);

// Using the efficient comparison to set z based on the equality of x and y
assign z = (x == y);

endmodule