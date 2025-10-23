module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg state; // 0 for state A, 1 for state B
always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 1; // Reset to state B
    end else begin
        case (state)
            1'b0: // State A
                if (~in) begin // Input is 0
                    state <= 1'b1; // Transition to state B
                end else begin
                    state <= 1'b0; // Stay in state A
                end
            1'b1: // State B
                if (~in) begin // Input is 0
                    state <= 1'b0; // Transition to state A
                end else begin
                    state <= 1'b1; // Stay in state B
                end
            default: state <= 1'b1; // Default to state B
        endcase
    end
end

// Output is determined by the state
assign out = state;

endmodule