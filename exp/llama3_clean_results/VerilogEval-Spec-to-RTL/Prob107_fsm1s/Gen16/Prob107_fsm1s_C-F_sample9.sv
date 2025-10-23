module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // State variable, 0 for B, 1 for A

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state B
        out <= 1; // Output for state B
    end else begin
        case (state)
            0: begin // State B
                if (~in) begin
                    state <= 1; // Transition to A on in=0
                    out <= 0; // Output for state A
                end else begin
                    state <= 0; // Stay in B on in=1
                    out <= 1; // Output for state B
                end
            end
            1: begin // State A
                if (~in) begin
                    state <= 0; // Transition to B on in=0
                    out <= 1; // Output for state B
                end else begin
                    state <= 1; // Stay in A on in=1
                    out <= 0; // Output for state A
                end
            end
        endcase
    end
end

endmodule