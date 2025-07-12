module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg state; // Current state: 0 - OFF, 1 - ON

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Synchronous reset to state OFF
        state <= 0;
    end else begin
        case(state)
            0: state <= j ? 1 : 0; // Transition to ON if j=1, stay in OFF if j=0
            1: state <= k ? 0 : 1; // Transition to OFF if k=1, stay in ON if k=0
            default: state <= 0; // Default to OFF for any other state (should not occur)
        endcase
    end
end

// Combinatorial logic for output
assign out = state;

endmodule