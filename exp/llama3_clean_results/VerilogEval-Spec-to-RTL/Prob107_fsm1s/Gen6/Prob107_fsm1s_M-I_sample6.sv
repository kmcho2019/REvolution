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
        out <= 1; // Reset output to 1 for state B
    end else begin
        if (state == 0) begin // Currently in state B
            if (!in) begin // in = 0
                state <= 1; // Transition to state A
                out <= 0; // Set output to 0 for state A
            end else begin // in = 1
                state <= 0; // Stay in state B
                out <= 1; // Keep output at 1 for state B
            end
        end else begin // Currently in state A
            if (!in) begin // in = 0
                state <= 0; // Transition to state B
                out <= 1; // Set output to 1 for state B
            end else begin // in = 1
                state <= 1; // Stay in state A
                out <= 0; // Keep output at 0 for state A
            end
        end
    end
end

endmodule