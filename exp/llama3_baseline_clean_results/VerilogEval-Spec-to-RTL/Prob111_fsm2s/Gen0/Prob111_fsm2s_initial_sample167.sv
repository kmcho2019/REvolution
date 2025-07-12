module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [1:0] state; // Current state
reg [1:0] next_state; // Next state

always @(*) begin
    case(state)
        0: // OFF state
            if (j)
                next_state = 1; // Transition to ON if j is 1
            else
                next_state = 0; // Stay in OFF if j is 0
        1: // ON state
            if (k)
                next_state = 0; // Transition to OFF if k is 1
            else
                next_state = 1; // Stay in ON if k is 0
        default:
            next_state = 0; // Default to OFF if state is invalid
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to OFF state if reset is high
    end else begin
        state <= next_state; // Update state at each clock cycle
    end
end

assign out = state[0]; // Output is 1 if state is ON, 0 if state is OFF

endmodule