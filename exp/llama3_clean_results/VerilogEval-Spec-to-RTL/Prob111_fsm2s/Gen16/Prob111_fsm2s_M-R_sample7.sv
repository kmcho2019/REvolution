module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // State register, 0 for OFF, 1 for ON

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to OFF state
        out <= 0;
    end else begin
        case (state)
            0: begin // OFF state
                if (j) begin
                    state <= 1; // Transition to ON
                    out <= 1;
                end else begin
                    state <= 0; // Stay in OFF
                    out <= 0;
                end
            end
            1: begin // ON state
                if (k) begin
                    state <= 0; // Transition to OFF
                    out <= 0;
                end else begin
                    state <= 1; // Stay in ON
                    out <= 1;
                end
            end
        endcase
    end
end

endmodule