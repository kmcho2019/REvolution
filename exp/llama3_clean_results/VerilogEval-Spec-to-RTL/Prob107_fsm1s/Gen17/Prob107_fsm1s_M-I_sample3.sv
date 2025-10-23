module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit state variable

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
        out <= 1'b1; // Output for state B
    end else begin
        case(state)
            1'b0: begin // State A
                if(in) begin
                    state <= 1'b0; // Stay in A if in=1
                    out <= 1'b0; // Output remains 0
                end else begin
                    state <= 1'b1; // Transition to B if in=0
                    out <= 1'b1; // Output becomes 1
                end
            end
            1'b1: begin // State B
                if(in) begin
                    state <= 1'b1; // Stay in B if in=1
                    out <= 1'b1; // Output remains 1
                end else begin
                    state <= 1'b0; // Transition to A if in=0
                    out <= 1'b0; // Output becomes 0
                end
            end
        endcase
    end
end

endmodule