module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: PULSE_STARTED, 2: PULSE_END

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        state <= 0; // IDLE state
        data_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin
                    state <= 1; // move to PULSE_STARTED state
                    data_out <= 0;
                end else begin
                    state <= 0; // stay in IDLE state
                    data_out <= 0;
                end
            end
            1: begin // PULSE_STARTED state
                if (~data_in) begin
                    state <= 2; // move to PULSE_END state
                    data_out <= 1;
                end else begin
                    state <= 1; // stay in PULSE_STARTED state
                    data_out <= 0;
                end
            end
            2: begin // PULSE_END state
                state <= 0; // move back to IDLE state
                data_out <= 0;
            end
        endcase
    end
end

endmodule