module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: PULSE_START, 2: PULSE_MIDDLE, 3: PULSE_END

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // IDLE
        data_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data_in) begin
                    state <= 1; // PULSE_START
                end else begin
                    state <= 0; // IDLE
                end
                data_out <= 0;
            end
            1: begin // PULSE_START
                if (data_in) begin
                    state <= 2; // PULSE_MIDDLE
                end else begin
                    state <= 0; // IDLE
                end
                data_out <= 0;
            end
            2: begin // PULSE_MIDDLE
                if (~data_in) begin
                    state <= 3; // PULSE_END
                end else begin
                    state <= 2; // PULSE_MIDDLE
                end
                data_out <= 0;
            end
            3: begin // PULSE_END
                state <= 0; // IDLE
                data_out <= 1;
            end
            default: begin
                state <= 0; // IDLE
                data_out <= 0;
            end
        endcase
    end
end

endmodule