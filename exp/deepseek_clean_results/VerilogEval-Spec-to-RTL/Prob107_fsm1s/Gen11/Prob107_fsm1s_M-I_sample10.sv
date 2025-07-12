module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to B
        end else begin
            // Simplified state transition logic
            state <= (state & in) | (~state & ~in);
        end
    end

    assign out = ~state;  // Output is inverse of state (1 for B, 0 for A)

endmodule