module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2 states: IDLE (0), PULSE_START (1), PULSE_END (2)
parameter IDLE = 2'b00, PULSE_START = 2'b01, PULSE_END = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= PULSE_START;
                end else begin
                    state <= IDLE;
                end
                data_out <= 0;
            end
            PULSE_START: begin
                if (~data_in) begin
                    state <= PULSE_END;
                end else begin
                    state <= PULSE_START;
                end
                data_out <= 0;
            end
            PULSE_END: begin
                state <= IDLE;
                data_out <= 1;
            end
            default: begin
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule