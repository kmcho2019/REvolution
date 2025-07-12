module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states using one-hot encoding
localparam STATE_B = 1'b0;
localparam STATE_A = 1'b1;

reg state; // State variable

// Sequential logic for state update and output
always @(posedge clk) begin
    if(reset) begin
        state <= STATE_B; // Reset to state B
        out <= 1'b1; // Output for state B
    end else begin
        case(state)
            STATE_B: begin
                if(!in) begin
                    state <= STATE_A; // Transition to state A
                    out <= 1'b0; // Output for state A
                end else begin
                    state <= STATE_B; // Stay in state B
                    out <= 1'b1; // Output for state B
                end
            end
            STATE_A: begin
                if(!in) begin
                    state <= STATE_B; // Transition to state B
                    out <= 1'b1; // Output for state B
                end else begin
                    state <= STATE_A; // Stay in state A
                    out <= 1'b0; // Output for state A
                end
            end
            default: begin
                state <= STATE_B; // Default state
                out <= 1'b1; // Output for default state
            end
        endcase
    end
end

endmodule