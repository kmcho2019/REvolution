module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg state; // 1-bit variable to hold the state (0 or 1)
reg next_state; // 1-bit variable to hold the next state (0 or 1)

// Directly assign the output based on the current state
assign out = (state == 1'b1)? 1'b1 : 1'b0;

// Combinational logic for next state
assign next_state = (state == 1'b0)? (in == 1'b0? 1'b1 : 1'b0) : (in == 1'b0? 1'b0 : 1'b1);

// Sequential logic for state update
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state 1
    end else begin
        state <= next_state;
    end
end

endmodule