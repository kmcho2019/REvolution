module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // Two states, B (2'b00) and A (2'b01)

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset state is B
        out <= 1'b1; // Output for state B
    end else begin
        case (state)
            2'b00: begin // State B
                if (~in) begin
                    state <= 2'b01; // Transition to A on in = 0
                    out <= 1'b0; // Output for state A
                end else begin
                    state <= 2'b00; // Stay in B on in = 1
                    out <= 1'b1; // Output remains for state B
                end
            end
            2'b01: begin // State A
                if (~in) begin
                    state <= 2'b00; // Transition to B on in = 0
                    out <= 1'b1; // Output for state B
                end else begin
                    state <= 2'b01; // Stay in A on in = 1
                    out <= 1'b0; // Output remains for state A
                end
            end
        endcase
    end
end

endmodule