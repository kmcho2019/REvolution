module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [0:0] state; // Using [0:0] for a single bit to match typical state encoding styles

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b1; // State B is 1, State A is 0
        out <= 1'b1;
    end else begin
        case (state)
            1'b1: begin // State B
                if (!in) begin
                    state <= 1'b0; // Go to state A
                    out <= 1'b0;
                end else begin
                    state <= 1'b1; // Stay in state B
                    out <= 1'b1;
                end
            end
            1'b0: begin // State A
                if (!in) begin
                    state <= 1'b1; // Go to state B
                    out <= 1'b1;
                end else begin
                    state <= 1'b0; // Stay in state A
                    out <= 1'b0;
                end
            end
        endcase
    end
end

endmodule