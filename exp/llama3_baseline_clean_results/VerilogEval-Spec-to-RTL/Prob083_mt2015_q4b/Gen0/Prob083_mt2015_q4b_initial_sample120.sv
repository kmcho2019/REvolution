module TopModule(
    input x,
    input y,
    output z
);

// Implementing XNOR logic using basic operators
assign z = ~(x ^ y);

endmodule