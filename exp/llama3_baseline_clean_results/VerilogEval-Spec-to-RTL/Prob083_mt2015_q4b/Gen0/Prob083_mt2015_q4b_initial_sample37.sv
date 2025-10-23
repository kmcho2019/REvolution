module TopModule(
    input x,
    input y,
    output z
);

assign z = ~(x ^ y); // This will be 1 when x and y are the same (either both 0 or both 1)

endmodule