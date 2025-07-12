module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg state; // 1-bit variable to hold the state (0 or 1)

// Directly assign the output based on the current state
assign out = (state == 1'b1)? 1'b1 : 1'b0;

// Sequential logic for state transitions
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state 1
    end else if (state == 1'b1) begin
        state <= (in == 1'b0)? 1'b0 : 1'b1;
    end else begin
        state <= (in == 1'b0)? 1'b1 : 1'b0;
    end
end

endmodule