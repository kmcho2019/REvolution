module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: PULSE_START, 2: PULSE_END

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // Reset state to IDLE
        data_out <= 0; // Reset data_out to 0
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin
                    state <= 1; // Transition to PULSE_START state
                    data_out <= 0; // data_out is 0 in IDLE state
                end else begin
                    state <= 0; // Stay in IDLE state
                    data_out <= 0; // data_out is 0 in IDLE state
                end
            end
            1: begin // PULSE_START state
                if (~data_in) begin
                    state <= 2; // Transition to PULSE_END state
                    data_out <= 0; // data_out is 0 in PULSE_START state
                end else begin
                    state <= 1; // Stay in PULSE_START state
                    data_out <= 0; // data_out is 0 in PULSE_START state
                end
            end
            2: begin // PULSE_END state
                state <= 0; // Transition back to IDLE state
                data_out <= 1; // data_out is 1 in PULSE_END state
            end
            default: begin
                state <= 0; // Reset to IDLE state
                data_out <= 0; // data_out is 0 in default state
            end
        endcase
    end
end

endmodule