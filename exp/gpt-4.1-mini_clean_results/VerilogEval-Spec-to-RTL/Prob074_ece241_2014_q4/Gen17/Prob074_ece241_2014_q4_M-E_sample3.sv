module TopModule (
    input clk,
    input x,
    output z
);

    // State registers
    reg q_xor, q_and, q_or;
    // Internal reset signal that is asserted only at the first clock to initialize flip-flops
    reg init_reset;

    // Generate combinational D inputs for flip-flops
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Initialize reset for first clock cycle after simulation start
    initial init_reset = 1'b1;

    always @(posedge clk) begin
        if (init_reset) begin
            // On first clock, reset flip-flops to zero
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
            init_reset <= 1'b0; // De-assert reset after first clock
        end else begin
            // Normal operation: update flip-flops with combinational inputs
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output is NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule