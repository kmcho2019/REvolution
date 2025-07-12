module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state;

// Determine next state using combinational logic
wire next_state;
assign next_state = (state &&!k) || (!state && j);

// Output logic based on current state
assign out = state;

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        state <= next_state; // Update state based on next_state logic
    end
end

endmodule