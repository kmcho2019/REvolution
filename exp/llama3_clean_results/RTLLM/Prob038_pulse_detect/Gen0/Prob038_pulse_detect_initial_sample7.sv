module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: PULSE_START, 2: PULSE_BODY

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // Reset to IDLE state
        data_out <= 0; // Reset data_out to 0
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin
                    state <= 1; // Move to PULSE_START state
                    data_out <= 0; // Set data_out to 0
                end else begin
                    state <= 0; // Stay in IDLE state
                    data_out <= 0; // Set data_out to 0
                end
            end
            1: begin // PULSE_START state
                if (~data_in) begin
                    state <= 2; // Move to PULSE_BODY state
                    data_out <= 0; // Set data_out to 0
                end else begin
                    state <= 1; // Stay in PULSE_START state
                    data_out <= 0; // Set data_out to 0
                end
            end
            2: begin // PULSE_BODY state
                if (~data_in) begin
                    state <= 0; // Move to IDLE state
                    data_out <= 1; // Set data_out to 1, indicating pulse
                end else begin
                    state <= 1; // Move back to PULSE_START state
                    data_out <= 0; // Set data_out to 0
                end
            end
            default: begin
                state <= 0; // Move to IDLE state
                data_out <= 0; // Set data_out to 0
            end
        endcase
    end
end

endmodule