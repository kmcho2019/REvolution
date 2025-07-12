module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg current_state; // current state

// Next state logic using Boolean equations
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b0; // Reset to OFF state
    end else begin
        // Compute next state based on current state and inputs
        current_state <= (~j & ~k & current_state) | (j & ~k & ~current_state) | (~k & current_state);
    end
end

// Output logic directly from state
assign out = current_state;

endmodule