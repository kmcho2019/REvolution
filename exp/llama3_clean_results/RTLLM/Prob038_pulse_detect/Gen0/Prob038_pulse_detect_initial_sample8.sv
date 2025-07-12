module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to represent the states
parameter IDLE = 2'b00, PULSE_START = 2'b01, PULSE_END = 2'b10;

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // Rising edge detected
                    state <= PULSE_START;
                    data_out <= 0;
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            PULSE_START: begin
                if (~data_in) begin // Falling edge detected after rising edge
                    state <= PULSE_END;
                    data_out <= 1; // Set data_out to 1 to indicate the end of a pulse
                end else begin
                    state <= PULSE_START;
                    data_out <= 0;
                end
            end
            PULSE_END: begin
                if (data_in) begin // If data_in is still 1, stay in PULSE_END state
                    state <= PULSE_END;
                    data_out <= 0; // data_out should be 0 after the pulse
                end else begin
                    state <= IDLE; // If data_in is 0, go back to IDLE state
                    data_out <= 0;
                end
            end
            default: begin
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule