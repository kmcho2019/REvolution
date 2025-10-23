module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: PULSE_RISING, 2: PULSE_FALLING, 3: PULSE_END
reg [1:0] next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // IDLE
        data_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data_in) begin
                    state <= 1; // PULSE_RISING
                end else begin
                    state <= 0; // IDLE
                end
                data_out <= 0;
            end
            1: begin // PULSE_RISING
                if (~data_in) begin
                    state <= 2; // PULSE_FALLING
                end else begin
                    state <= 1; // PULSE_RISING
                end
                data_out <= 0;
            end
            2: begin // PULSE_FALLING
                if (~data_in) begin
                    state <= 3; // PULSE_END
                end else begin
                    state <= 2; // PULSE_FALLING
                end
                data_out <= 0;
            end
            3: begin // PULSE_END
                if (~data_in) begin
                    state <= 0; // IDLE
                    data_out <= 1;
                end else begin
                    state <= 2; // PULSE_FALLING
                    data_out <= 0;
                end
            end
        endcase
    end
end

endmodule