module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit variable to hold the state

// Sequential logic for state transitions
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
        out <= 1'b1;
    end else begin
        state <= ~state & ~in | state & in; // Next state logic
        out <= state; // Directly assign output based on state
    end
end

endmodule