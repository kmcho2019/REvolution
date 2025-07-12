module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: PULSE_START, 2: PULSE_END

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // Reset to IDLE state
        data_out <= 0; // Reset output to 0
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin
                    state <= 1; // Transition to PULSE_START state
                    data_out <= 0; // Output remains 0
                end else begin
                    state <= 0; // Stay in IDLE state
                    data_out <= 0; // Output remains 0
                end
            end
            1: begin // PULSE_START state
                if (~data_in) begin
                    state <= 2; // Transition to PULSE_END state
                    data_out <= 1; // Output is 1, indicating pulse end
                end else begin
                    state <= 1; // Stay in PULSE_START state
                    data_out <= 0; // Output remains 0
                end
            end
            2: begin // PULSE_END state
                state <= 0; // Transition back to IDLE state
                data_out <= 0; // Output returns to 0
            end
            default: begin
                state <= 0; // Default: go back to IDLE state
                data_out <= 0; // Output reset to 0
            end
        endcase
    end
end

endmodule