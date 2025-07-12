module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg current_state; // current state

// State register update with direct next state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b0; // OFF state
    end else begin
        case (current_state)
            1'b0: current_state <= j ? 1'b1 : 1'b0; // OFF state transitions
            1'b1: current_state <= k ? 1'b0 : 1'b1; // ON state transitions
            default: current_state <= 1'b0;
        endcase
    end
end

// Direct output from state, minimizing additional logic
assign out = current_state;

endmodule