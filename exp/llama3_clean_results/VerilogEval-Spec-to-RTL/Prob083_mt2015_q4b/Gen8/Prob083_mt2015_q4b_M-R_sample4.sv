module TopModule(
    input  x,
    input  y,
    output z
);

// Directly assign the output z without an intermediate wire
assign z = ~(x ^ y);

endmodule