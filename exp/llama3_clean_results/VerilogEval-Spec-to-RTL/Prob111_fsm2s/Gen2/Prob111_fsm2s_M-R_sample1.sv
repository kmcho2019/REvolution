module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg state; // Using a reg for the state

// State register with synchronous reset
always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to OFF state (0)
    end else begin
        // Next state logic based on current state and inputs
        case (state)
            0: state <= j ? 1 : 0; // OFF state transitions
            1: state <= k ? 0 : 1; // ON state transitions
            default: state <= 0; // Default to OFF for any unspecified state
        endcase
    end
end

// Output logic based directly on the state
assign out = state;

endmodule