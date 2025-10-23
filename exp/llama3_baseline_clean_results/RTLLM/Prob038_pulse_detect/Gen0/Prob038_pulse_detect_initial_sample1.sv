module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: PULSE_START, 2: PULSE_END

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // IDLE state
        data_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin
                    state <= 1; // Move to PULSE_START state
                    data_out <= 0;
                end else begin
                    state <= 0; // Stay in IDLE state
                    data_out <= 0;
                end
            end
            1: begin // PULSE_START state
                if (data_in) begin
                    state <= 2; // Move to PULSE_END state
                    data_out <= 0;
                end else begin
                    state <= 0; // Return to IDLE state
                    data_out <= 0;
                end
            end
            2: begin // PULSE_END state
                data_out <= 1; // Set data_out to 1
                state <= 0; // Return to IDLE state
            end
            default: begin
                state <= 0; // Return to IDLE state
                data_out <= 0;
            end
        endcase
    end
end

endmodule