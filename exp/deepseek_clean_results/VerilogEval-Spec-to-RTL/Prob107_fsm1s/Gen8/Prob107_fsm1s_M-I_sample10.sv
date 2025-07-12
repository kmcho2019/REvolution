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
            state <= state ^ ~in;  // Flips state when in=0, maintains when in=1
        end
    end

    assign out = ~state;  // 1 when B (0), 0 when A (1)

endmodule