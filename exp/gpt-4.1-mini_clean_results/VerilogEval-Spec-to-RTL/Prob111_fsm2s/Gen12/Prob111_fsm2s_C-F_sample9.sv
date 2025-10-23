module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    reg state; // 0 = OFF, 1 = ON

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;   // OFF state
            out   <= 1'b0;   // Output for OFF state
        end else begin
            // State transition
            state <= state ? (k ? 1'b0 : 1'b1) : (j ? 1'b1 : 1'b0);
            // Moore output depends only on state
            out <= state;
        end
    end

endmodule