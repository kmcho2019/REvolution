module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg current_state; // current state

// Simplified next state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b0; // Reset to OFF state
    end else begin
        current_state <= (current_state && !k) || (!current_state && j);
    end
end

// Output logic directly from state
assign out = current_state;

endmodule