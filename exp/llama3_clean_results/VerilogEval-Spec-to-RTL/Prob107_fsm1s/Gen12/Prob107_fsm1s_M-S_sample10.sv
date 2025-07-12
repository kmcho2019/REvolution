module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit state variable

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1; // Reset to state B (out = 1)
        out <= 1; // Reset output to 1
    end else begin
        case(state)
            1'b0: begin // State A
                if(!in) begin
                    state <= 1; // Transition to state B
                    out <= 1; // Update output to 1
                end else begin
                    state <= 0; // Stay in state A
                    out <= 0; // Keep output as 0
                end
            end
            1'b1: begin // State B
                if(!in) begin
                    state <= 0; // Transition to state A
                    out <= 0; // Update output to 0
                end else begin
                    state <= 1; // Stay in state B
                    out <= 1; // Keep output as 1
                end
            end
        endcase
    end
end

endmodule