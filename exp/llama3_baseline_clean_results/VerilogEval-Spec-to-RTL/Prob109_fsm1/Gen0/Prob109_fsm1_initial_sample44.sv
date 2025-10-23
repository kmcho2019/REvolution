module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg state; // Using a single reg to represent the state

always @(*) begin
    if (areset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        case(state)
            1'b0: begin // State A
                if (~in) begin
                    state <= 1'b1; // Transition to B on in=0
                end else begin
                    state <= 1'b0; // Stay in A on in=1
                end
            end
            1'b1: begin // State B
                if (~in) begin
                    state <= 1'b0; // Transition to A on in=0
                end else begin
                    state <= 1'b1; // Stay in B on in=1
                end
            end
            default: state <= 1'b1; // Default to state B
        endcase
    end
end

always @(*) begin
    case(state)
        1'b0: out <= 1'b0; // Output for state A
        1'b1: out <= 1'b1; // Output for state B
        default: out <= 1'b1; // Default output if state is unknown
    endcase
end

endmodule