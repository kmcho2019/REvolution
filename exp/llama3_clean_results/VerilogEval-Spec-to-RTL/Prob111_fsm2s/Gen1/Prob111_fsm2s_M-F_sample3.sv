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
        out <= 0; // Directly set output to 0 on reset for clarity
    end else begin
        case(state)
            0: begin
                if (j) begin
                    state <= 1; // Transition to ON if j=1
                end else begin
                    state <= 0; // Stay in OFF if j=0
                end
            end
            1: begin
                if (k) begin
                    state <= 0; // Transition to OFF if k=1
                end else begin
                    state <= 1; // Stay in ON if k=0
                end
            end
            default: state <= 0; // Default to OFF for any other state (should not occur)
        endcase
        // Update output based on the new state
        out <= state;
    end
end

endmodule