module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit state variable

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
        out <= 1'b1; // Output for state B
    end else begin
        if (~in) begin
            state <= ~state; // Update state based on input
            out <= ~state; // Update output based on new state
        end
    end
end

endmodule