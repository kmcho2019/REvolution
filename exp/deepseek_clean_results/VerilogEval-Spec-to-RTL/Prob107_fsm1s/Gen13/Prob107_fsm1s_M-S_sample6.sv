module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state; // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 0; // Reset to state B
        end else begin
            if (state) begin // State A
                state <= in; // stays A if in=1, goes to B if in=0
            end else begin   // State B
                state <= in ? 0 : 1; // stays B if in=1, goes to A if in=0
            end
        end
    end

    assign out = ~state; // out=1 when state B (0), out=0 when state A (1)

endmodule