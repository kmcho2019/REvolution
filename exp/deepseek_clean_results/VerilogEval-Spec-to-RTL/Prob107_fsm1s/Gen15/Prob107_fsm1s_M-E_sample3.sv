module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state; // state=out (1=B, 0=A)

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b1; // Reset to state B (out=1)
        end else begin
            state <= state ^ ~in; // Compact transition logic
        end
    end

    assign out = state; // Output directly follows state

endmodule