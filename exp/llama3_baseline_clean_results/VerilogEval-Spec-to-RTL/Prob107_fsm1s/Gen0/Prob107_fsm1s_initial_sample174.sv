module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // B (2'b00), A (2'b01)

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset state B
        out <= 1'b1; // Output for state B
    end else begin
        case (state)
            2'b00: begin // State B
                if (in == 1'b0) begin
                    state <= 2'b01; // Transition to A
                    out <= 1'b0; // Output for state A
                end else begin
                    state <= 2'b00; // Stay in B
                    out <= 1'b1; // Output for state B
                end
            end
            2'b01: begin // State A
                if (in == 1'b0) begin
                    state <= 2'b00; // Transition to B
                    out <= 1'b1; // Output for state B
                end else begin
                    state <= 2'b01; // Stay in A
                    out <= 1'b0; // Output for state A
                end
            end
            default: state <= 2'b00; // Default to B if invalid state
        endcase
    end
end

endmodule