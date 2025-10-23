module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state; // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0; // Reset to state B
        end else begin
            // Simplified boolean state transition
            state <= (state & in) | (~state & ~in);
        end
    end

    assign out = ~state; // out=1 when state B (0), out=0 when state A (1)

endmodule