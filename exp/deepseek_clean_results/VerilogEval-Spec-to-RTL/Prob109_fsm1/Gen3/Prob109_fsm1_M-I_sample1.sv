module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Single-bit state register (0=A, 1=B)
    reg state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Async reset to state B
        end else begin
            // Next state is current state XOR input (simplified from truth table)
            state <= state ^ ~in;
        end
    end

    // Output is the state bit directly (Moore machine)
    assign out = state;

endmodule