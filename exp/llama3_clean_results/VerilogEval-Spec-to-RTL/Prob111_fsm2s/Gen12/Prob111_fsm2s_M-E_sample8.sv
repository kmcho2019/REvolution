module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Single-bit state register for OFF (0) and ON (1) states

// Output logic
assign out = state; // Directly assign state value to output

// Next state logic
wire next_state;
assign next_state = (state == 1'b0) ? j : ~k;

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        state <= next_state; // Update state based on next state logic
    end
end

endmodule