module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg state;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        case (state)
            1'b1: // State B
                if (~in) begin
                    state <= 1'b0; // Transition to A on in = 0
                end else begin
                    state <= 1'b1; // Stay in B on in = 1
                end
            1'b0: // State A
                state <= 1'b1; // Always transition to B
            default:
                state <= 1'b1; // Default to B
        endcase
    end
end

// Continuous assignment for output
assign out = state;

endmodule