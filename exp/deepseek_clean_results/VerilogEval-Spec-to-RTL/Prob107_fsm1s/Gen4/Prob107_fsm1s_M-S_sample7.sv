module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;  // Reset to state B
        end else begin
            state <= in ? state : ~state;  // Simple transition logic
        end
    end

    assign out = ~state;  // Output is inverse of state

endmodule