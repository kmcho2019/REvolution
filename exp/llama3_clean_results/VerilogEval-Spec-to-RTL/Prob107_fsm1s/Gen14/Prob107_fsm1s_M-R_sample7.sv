module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit state variable

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B (out=1)
        out <= 1'b1;
    end else begin
        case(state)
            1'b0: begin // State A
                if(in) begin
                    state <= 1'b0; // Stay in state A
                end else begin
                    state <= 1'b1; // Transition to state B
                end
                out <= 1'b0;
            end
            1'b1: begin // State B
                if(in) begin
                    state <= 1'b1; // Stay in state B
                end else begin
                    state <= 1'b0; // Transition to state A
                end
                out <= 1'b1;
            end
        endcase
    end
end

endmodule