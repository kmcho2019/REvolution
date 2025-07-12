module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to store the current state
parameter IDLE = 2'b00; // Initial state: idle
parameter RISING = 2'b01; // State: rising edge detected
parameter FALLING = 2'b10; // State: falling edge detected

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Reset state to idle
        data_out <= 0; // Reset output to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // Rising edge detected
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    state <= IDLE; // Stay in idle state
                    data_out <= 0;
                end
            end
            RISING: begin
                if (data_in) begin // Still in rising state
                    state <= RISING;
                    data_out <= 0;
                end else begin // Falling edge detected
                    state <= FALLING;
                    data_out <= 0;
                end
            end
            FALLING: begin
                if (~data_in) begin // Falling edge confirmed
                    state <= IDLE; // Transition to idle state
                    data_out <= 1; // Set output to 1 (pulse detected)
                end else begin // Not a falling edge
                    state <= RISING; // Transition to rising state
                    data_out <= 0;
                end
            end
            default: begin
                state <= IDLE; // Default state
                data_out <= 0;
            end
        endcase
    end
end

endmodule