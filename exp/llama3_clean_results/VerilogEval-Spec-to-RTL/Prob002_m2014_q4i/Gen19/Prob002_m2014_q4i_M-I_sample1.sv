module TopModule(
    output out
);
    // Directly assign the output to a constant value for simplicity and efficiency.
    // Synthesis tools will likely infer this as a constant driver or a simple buffer.
    assign out = 1'b0;

endmodule