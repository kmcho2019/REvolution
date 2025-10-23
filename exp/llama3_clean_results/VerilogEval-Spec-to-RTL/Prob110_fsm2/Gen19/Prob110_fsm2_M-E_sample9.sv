module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg current_state; // current state

// Flip-Flop to store the current state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b0; // Reset to state 0
    end else begin
        // Next state logic using a multiplexer
        case (current_state)
            1'b0: current_state <= (j)? 1'b1 : 1'b0; // State 0 to State 1 if j is 1
            1'b1: current_state <= (k)? 1'b0 : 1'b1; // State 1 to State 0 if k is 1
            default: current_state <= 1'b0; // Default to State 0
        endcase
    end
end

// Output logic directly from state
assign out = current_state;

endmodule