module TopModule(
    input x,
    input y,
    output z
);

// Directly assign the output z the value of the simplified expression !(x ^ y)
assign z = ~(x ^ y);

endmodule