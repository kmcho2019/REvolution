module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Single bit state: 0=B, 1=A
    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to state B
        end else begin
            state <= (state & in) | (~state & ~in);
        end
    end

    assign out = ~state;  // 1 when in state B (0), 0 when in state A (1)

endmodule