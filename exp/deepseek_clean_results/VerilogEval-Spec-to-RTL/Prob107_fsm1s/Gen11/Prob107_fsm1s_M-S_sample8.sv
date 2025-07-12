module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;  // Reset to state B (0)
        end else begin
            if (state) begin  // Current state A
                state <= in;  // Stay in A if in=1, else go to B
            end else begin    // Current state B
                state <= ~in; // Go to A if in=0, else stay in B
            end
        end
    end

    assign out = ~state;  // out=1 when state B (0), out=0 when state A (1)

endmodule