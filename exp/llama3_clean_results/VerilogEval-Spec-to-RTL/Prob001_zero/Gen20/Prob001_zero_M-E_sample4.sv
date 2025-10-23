module TopModule (
    output zero,
    input clk // Input clock signal
);
    reg internal_zero; // Internal register to hold the constant value
    initial internal_zero = 1'b0; // Initialize the register with 0
    always @(posedge clk) // This always block is intentionally left empty
        // to illustrate the concept, but in practice, it would contain
        // the logic to update the register, which in this case is never needed.
    assign zero = internal_zero; // Assign the internal register value to the output
endmodule