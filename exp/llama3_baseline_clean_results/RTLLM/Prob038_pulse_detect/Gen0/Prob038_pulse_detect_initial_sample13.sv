module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: PULSE_START, 2: PULSE_END
reg [1:0] next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // IDLE
        data_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data_in) begin
                    state <= 1; // PULSE_START
                    data_out <= 0;
                end else begin
                    state <= 0; // IDLE
                    data_out <= 0;
                end
            end
            1: begin // PULSE_START
                if (~data_in) begin
                    state <= 2; // PULSE_END
                    data_out <= 1;
                end else begin
                    state <= 1; // PULSE_START
                    data_out <= 0;
                end
            end
            2: begin // PULSE_END
                state <= 0; // IDLE
                data_out <= 0;
            end
            default: begin
                state <= 0; // IDLE
                data_out <= 0;
            end
        endcase
    end
end

endmodule