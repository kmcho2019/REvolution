module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 0 for A, 1 for B

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        case (state)
            1'b0: begin // State A
                if (!in) begin
                    state <= 1'b1; // Transition to B
                end else begin
                    state <= 1'b0; // Stay in A
                end
            end
            1'b1: begin // State B
                if (!in) begin
                    state <= 1'b0; // Transition to A
                end else begin
                    state <= 1'b1; // Stay in B
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        1'b0: out = 1'b0; // Output for state A
        1'b1: out = 1'b1; // Output for state B
    endcase
end

endmodule