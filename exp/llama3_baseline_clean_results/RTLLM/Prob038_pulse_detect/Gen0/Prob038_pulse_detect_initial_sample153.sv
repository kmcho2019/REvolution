module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // State register
parameter IDLE = 2'b00; // Initial state
parameter RISING = 2'b01; // Rising edge detected
parameter FALLING = 2'b10; // Falling edge detected

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Set state to initial state
        data_out <= 0; // Set output to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // Check if input is high
                    state <= RISING; // Transition to RISING state
                    data_out <= 0; // Set output to 0
                end else begin
                    state <= IDLE; // Stay in IDLE state
                    data_out <= 0; // Set output to 0
                end
            end
            RISING: begin
                if (~data_in) begin // Check if input falls
                    state <= FALLING; // Transition to FALLING state
                    data_out <= 1; // Set output to 1 (pulse detected)
                end else begin
                    state <= RISING; // Stay in RISING state
                    data_out <= 0; // Set output to 0
                end
            end
            FALLING: begin
                state <= IDLE; // Transition back to IDLE state
                data_out <= 0; // Set output to 0
            end
            default: begin
                state <= IDLE; // Default to IDLE state
                data_out <= 0; // Set output to 0
            end
        endcase
    end
end

endmodule