module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    reg state; // 0 = B, 1 = A

    always @(posedge clk) begin
        if (reset) begin
            state <= 0; // Reset to state B
            out <= 1;   // Output for state B
        end else begin
            case (state)
                0: begin // State B
                    state <= in ? 0 : 1;
                    out <= in ? 1 : 0;
                end
                1: begin // State A
                    state <= in ? 1 : 0;
                    out <= in ? 0 : 1;
                end
            endcase
        end
    end

endmodule