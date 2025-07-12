module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: PULSE_START, 2: PULSE_END

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        state <= 0; // initial state: IDLE
        data_out <= 0; // no pulse
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin // rising edge of data_in
                    state <= 1; // transition to PULSE_START state
                    data_out <= 0; // no pulse
                end else begin
                    state <= 0; // stay in IDLE state
                    data_out <= 0; // no pulse
                end
            end
            1: begin // PULSE_START state
                if (~data_in) begin // falling edge of data_in
                    state <= 2; // transition to PULSE_END state
                end else begin
                    state <= 1; // stay in PULSE_START state
                end
                data_out <= 0; // no pulse
            end
            2: begin // PULSE_END state
                state <= 0; // transition back to IDLE state
                data_out <= 1; // pulse detected
            end
        endcase
    end
end

endmodule