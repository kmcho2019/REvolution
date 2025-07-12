module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit variable to hold the state (A=0, B=1)

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
        out <= 1'b1; // Output for state B
    end else begin
        case(state)
            1'b0: begin // State A
                out <= 1'b0; // Output for state A
                if(in == 1'b0) begin
                    state <= 1'b1; // From A, in=0 -> B
                end else begin
                    state <= 1'b0; // From A, in=1 -> A
                end
            end
            1'b1: begin // State B
                out <= 1'b1; // Output for state B
                if(in == 1'b0) begin
                    state <= 1'b0; // From B, in=0 -> A
                end else begin
                    state <= 1'b1; // From B, in=1 -> B
                end
            end
            default: begin
                state <= 1'bx; // Should not occur
                out <= 1'bx; // Should not occur
            end
        endcase
    end
end

endmodule