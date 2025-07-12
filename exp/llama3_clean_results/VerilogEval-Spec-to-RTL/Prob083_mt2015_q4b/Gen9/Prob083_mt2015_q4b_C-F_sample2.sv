module TopModule(
    input x,
    input y,
    output z
);

// Explicitly define z as a wire
wire z_wire;

// Assign z_wire the value of the expression ~(x ^ y)
assign z_wire = ~(x ^ y);

// Assign the output z the value of z_wire
assign z = z_wire;

endmodule