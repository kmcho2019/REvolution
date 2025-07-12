module TopModule(
    input x,
    input y,
    output z
);
    // Using the equality check for its simplicity and directness
    assign z = (x == y);
endmodule