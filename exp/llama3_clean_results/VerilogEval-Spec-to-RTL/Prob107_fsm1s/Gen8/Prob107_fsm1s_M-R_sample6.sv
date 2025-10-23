module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// State register
reg state;

// Combinational logic for next state
wire next_state;
assign next_state = (state == 1'b0)? ~in : in;

// Sequential logic for state update
always @(posedge clk) begin
    if(reset) begin
        // Synchronous reset to state B (0)
        state <= 1'b0;
    end else begin
        // Update state based on next state logic
        state <= next_state;
    end
end

// Output assignment based on current state
assign out = (state == 1'b0); // Out is 1 in state B (0) and 0 in state A (1)

endmodule