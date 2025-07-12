module TopModule(
    input x,
    input y,
    output z
);

// Implementing the K-map simplified expression using AOI logic
assign z = ~(x & ~y) & ~(~x & y);

endmodule