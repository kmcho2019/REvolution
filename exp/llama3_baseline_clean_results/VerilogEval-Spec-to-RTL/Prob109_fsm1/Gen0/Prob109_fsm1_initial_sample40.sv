module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Reset to state B
        out <= 1'b1;
    end else begin
        case(state)
            1'b0: begin // State A
                if (~in) begin
                    state <= 1'b1; // Transition to state B
                    out <= 1'b1;
                end else begin
                    state <= 1'b0; // Stay in state A
                    out <= 1'b0;
                end
            end
            1'b1: begin // State B
                if (in) begin
                    state <= 1'b1; // Stay in state B
                    out <= 1'b1;
                end else begin
                    state <= 1'b0; // Transition to state A
                    out <= 1'b0;
                end
            end
        endcase
    end
end

endmodule