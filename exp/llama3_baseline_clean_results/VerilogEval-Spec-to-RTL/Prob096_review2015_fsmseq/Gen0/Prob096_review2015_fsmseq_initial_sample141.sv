module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state; // States for sequence matching: idle, seq_1, seq_11, seq_110, seq_1101

always_ff @(posedge clk) begin
    if (reset) begin // Reset is active high, synchronous
        state <= 0; // Reset state to idle (0)
        start_shifting <= 0;
    end else begin
        case(state)
            0: begin // Idle state, waiting for '1'
                if (data == 1'b1) begin
                    state <= 1; // Move to seq_1 state if '1' is seen
                end else begin
                    state <= 0; // Stay in idle if not '1'
                end
            end
            1: begin // seq_1 state, waiting for '1' again
                if (data == 1'b1) begin
                    state <= 2; // Move to seq_11 state if '1' is seen again
                end else if (data == 1'b0) begin
                    state <= 0; // If '0' is seen, restart to idle
                end else begin
                    state <= 1; // Stay in seq_1 if still '1'
                end
            end
            2: begin // seq_11 state, waiting for '0'
                if (data == 1'b0) begin
                    state <= 3; // Move to seq_110 state if '0' is seen
                end else begin
                    state <= 0; // If not '0', restart to idle
                end
            end
            3: begin // seq_110 state, waiting for '1'
                if (data == 1'b1) begin
                    state <= 4; // Move to seq_1101 state if '1' is seen
                end else begin
                    state <= 0; // If not '1', restart to idle
                end
            end
            4: begin // seq_1101 state, set start_shifting to 1
                start_shifting <= 1'b1;
            end
            default: begin // This should not happen, but included for completeness
                state <= 0;
                start_shifting <= 1'b0;
            end
        endcase
    end
end

endmodule