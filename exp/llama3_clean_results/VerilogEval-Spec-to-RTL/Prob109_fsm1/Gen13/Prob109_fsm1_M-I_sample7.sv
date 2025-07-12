module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state_reg; // 1-bit register to hold the state
wire next_state; // next state signal
assign out = state_reg; // assign output as the current state

// Logic for next state remains the same due to simplicity and efficiency
assign next_state = state_reg ^ (~in); 

// Changed to synchronous reset for potential area and power savings
always @(posedge clk) begin
    if (areset) begin
        state_reg <= 1'b1; // synchronous reset to state B
    end else begin
        state_reg <= next_state; // update state register
    end
end

endmodule