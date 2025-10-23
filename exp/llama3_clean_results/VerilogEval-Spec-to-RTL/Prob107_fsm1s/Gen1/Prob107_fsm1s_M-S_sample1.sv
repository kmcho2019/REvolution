module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Using a 1-bit register to represent the state

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
        out <= 1; // Output for state B
    end else begin
        case({state, in})
            2'b00: begin // State B, in = 0
                state <= 1; // Go to state A
                out <= 0; // Output for state A
            end
            2'b01: begin // State B, in = 1
                state <= 0; // Stay in state B
                out <= 1; // Output for state B
            end
            2'b10: begin // State A, in = 0
                state <= 0; // Go to state B
                out <= 1; // Output for state B
            end
            2'b11: begin // State A, in = 1
                state <= 1; // Stay in state A
                out <= 0; // Output for state A
            end
        endcase
    end
end

endmodule