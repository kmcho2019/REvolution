module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;  // 0 = OFF, 1 = ON

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Synchronous reset to OFF
        end else begin
            // Toggle logic: j sets, k resets (priority to reset if both are 1)
            state <= (state & ~k) | (~state & j);
        end
    end

    assign out = state;  // Moore output

endmodule