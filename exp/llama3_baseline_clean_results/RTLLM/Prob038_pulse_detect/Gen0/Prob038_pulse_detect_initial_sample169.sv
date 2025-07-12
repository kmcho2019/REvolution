module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: PULSE_START, 2: PULSE_END

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= 0; // IDLE state
        data_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin
                    state <= 1; // Transition to PULSE_START state
                end else begin
                    state <= 0; // Remain in IDLE state
                end
                data_out <= 0;
            end
            1: begin // PULSE_START state
                if (~data_in) begin
                    state <= 2; // Transition to PULSE_END state
                end else begin
                    state <= 1; // Remain in PULSE_START state
                end
                data_out <= 0;
            end
            2: begin // PULSE_END state
                state <= 0; // Transition back to IDLE state
                data_out <= 1; // Set data_out to 1 to indicate the end of a pulse
            end
            default: begin
                state <= 0; // IDLE state
                data_out <= 0;
            end
        endcase
    end
end

endmodule