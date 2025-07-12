module TopModule(
    input x,
    input y,
    output z
);

// Directly assign z the value of the expression ~(x ^ y)
assign z = ~(x ^ y);

endmodule