module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to hold the current state
parameter IDLE = 2'b00, RISING = 2'b01, FALLING = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // Rising edge detected
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            RISING: begin
                if (~data_in) begin // Falling edge detected
                    state <= FALLING;
                    data_out <= 0;
                end else begin
                    state <= RISING;
                    data_out <= 0;
                end
            end
            FALLING: begin
                if (~data_in) begin // Pulse ended, set data_out to 1
                    data_out <= 1;
                    state <= IDLE;
                end else begin
                    state <= RISING;
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