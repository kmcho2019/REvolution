module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg current_state; // Current state (1-bit)

// State register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 0; // Reset to OFF state
    end else begin
        case (current_state)
            0: current_state <= j? 1 : 0; // Transition from OFF to ON or stay in OFF
            1: current_state <= k? 0 : 1; // Transition from ON to OFF or stay in ON
            default: current_state <= 0; // Default to OFF state
        endcase
    end
end

// Output logic directly from state
assign out = current_state;

endmodule