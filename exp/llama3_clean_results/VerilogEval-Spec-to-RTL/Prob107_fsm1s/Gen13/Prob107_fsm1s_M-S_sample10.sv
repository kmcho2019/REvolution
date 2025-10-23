module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Using a 1-bit register to represent the state

// Sequential logic for state update and output
always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
        out <= 1; // Output is 1 in state B
    end else begin
        case(state)
            0: begin // State B
                if (~in) begin
                    state <= 1; // Transition to state A
                    out <= 0; // Output is 0 in state A
                end else begin
                    state <= 0; // Stay in state B
                    out <= 1; // Output remains 1 in state B
                end
            end
            1: begin // State A
                if (~in) begin
                    state <= 0; // Transition to state B
                    out <= 1; // Output is 1 in state B
                end else begin
                    state <= 1; // Stay in state A
                    out <= 0; // Output remains 0 in state A
                end
            end
        endcase
    end
end

endmodule