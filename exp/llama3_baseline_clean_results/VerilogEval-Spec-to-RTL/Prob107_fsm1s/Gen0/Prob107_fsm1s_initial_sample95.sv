module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 0: A, 1: B

always @ (posedge clk) begin
    if (reset) begin
        state <= 1; // Reset to state B
        out <= 1; // out is 1 in state B
    end else begin
        case (state)
            0: begin // State A
                if (!in) begin
                    state <= 1; // Transition to state B
                    out <= 1; // out is 1 in state B
                end else begin
                    state <= 0; // Stay in state A
                    out <= 0; // out is 0 in state A
                end
            end
            1: begin // State B
                if (!in) begin
                    state <= 0; // Transition to state A
                    out <= 0; // out is 0 in state A
                end else begin
                    state <= 1; // Stay in state B
                    out <= 1; // out is 1 in state B
                end
            end
        endcase
    end
end

endmodule