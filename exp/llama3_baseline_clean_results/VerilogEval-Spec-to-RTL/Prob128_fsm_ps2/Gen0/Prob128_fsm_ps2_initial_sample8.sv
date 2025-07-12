module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to IDLE state
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (in[3]) begin
                    state <= 1; // Transition to BYTE1 state
                end else begin
                    state <= 0; // Stay in IDLE state
                end
                done_reg <= 0;
            end
            1: begin // BYTE1 state
                state <= 2; // Transition to BYTE2 state
                if (in[3]) begin
                    state <= 0; // If in[3] is high, restart the search
                end
                done_reg <= 0;
            end
            2: begin // BYTE2 state
                state <= 0; // Return to IDLE state after 3 bytes
                if (in[3]) begin
                    state <= 0; // If in[3] is high, restart the search
                end
                done_reg <= 1; // Signal done after the third byte
            end
        endcase
    end
end

assign done = done_reg;

endmodule