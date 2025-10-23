module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to keep track of the current state
parameter IDLE = 2'b00; // Initial state
parameter RISING = 2'b01; // Rising edge detected
parameter HIGH = 2'b10; // High state
parameter FALLING = 2'b11; // Falling edge detected

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Set the state register to the initial state
        data_out <= 0; // Set the output to 0, indicating no pulse
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // Check for rising edge
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    state <= IDLE; // Stay in the IDLE state if no rising edge
                    data_out <= 0;
                end
            end
            RISING: begin
                if (data_in) begin // Check for high state
                    state <= HIGH;
                    data_out <= 0;
                end else begin
                    state <= IDLE; // Return to IDLE state if no high state
                    data_out <= 0;
                end
            end
            HIGH: begin
                if (data_in) begin // Stay in the high state
                    state <= HIGH;
                    data_out <= 0;
                end else begin
                    state <= FALLING; // Transition to falling state
                    data_out <= 0;
                end
            end
            FALLING: begin
                if (~data_in) begin // Check for falling edge
                    state <= IDLE; // Return to IDLE state
                    data_out <= 1; // Set the output to 1, indicating the end of a pulse
                end else begin
                    state <= HIGH; // Stay in the high state if no falling edge
                    data_out <= 0;
                end
            end
            default: begin
                state <= IDLE; // Default to the IDLE state
                data_out <= 0;
            end
        endcase
    end
end

endmodule