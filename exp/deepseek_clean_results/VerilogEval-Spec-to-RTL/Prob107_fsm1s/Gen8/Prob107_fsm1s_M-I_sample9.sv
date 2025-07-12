module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State register (0=B, 1=A)
    reg state;

    // Optimized state transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to state B
        end else begin
            state <= (state & in) | (~state & ~in);
        end
    end

    // Output logic (Moore)
    assign out = ~state;  // out=1 when in state B (0), out=0 when in state A (1)

endmodule