module TopModule(
    input x,
    input y,
    output z
);

// Directly assign the value of the simplified expression!(x ^ y) to z
assign z =!(x ^ y);

endmodule