module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state;

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
        out <= 1'b0;
    end else begin
        case(state)
            1'b0: begin // OFF state
                if (j == 1'b1) begin
                    state <= 1'b1; // Transition to ON state if j is high
                    out <= 1'b1;
                end else begin
                    state <= 1'b0; // Remain in OFF state if j is low
                    out <= 1'b0;
                end
            end
            1'b1: begin // ON state
                if (k == 1'b1) begin
                    state <= 1'b0; // Transition to OFF state if k is high
                    out <= 1'b0;
                end else begin
                    state <= 1'b1; // Remain in ON state if k is low
                    out <= 1'b1;
                end
            end
        endcase
    end
end

endmodule