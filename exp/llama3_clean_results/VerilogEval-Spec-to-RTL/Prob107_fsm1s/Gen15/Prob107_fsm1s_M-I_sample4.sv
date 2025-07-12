module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit state variable

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1; // Reset to state B (out=1)
        out <= 1;
    end else begin
        case(state)
            1'b0: begin // State A
                if(~in) begin
                    state <= 1; // Transition from A to B
                    out <= 1;
                end else begin
                    state <= 0; // Stay in A
                    out <= 0;
                end
            end
            1'b1: begin // State B
                if(~in) begin
                    state <= 0; // Transition from B to A
                    out <= 0;
                end else begin
                    state <= 1; // Stay in B
                    out <= 1;
                end
            end
        endcase
    end
end

endmodule