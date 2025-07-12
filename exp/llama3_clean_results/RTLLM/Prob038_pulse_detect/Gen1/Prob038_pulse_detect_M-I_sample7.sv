module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the state machine
enum logic [1:0] {
    IDLE,
    PULSE_RISING,
    PULSE_FALLING
} state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Initial state: IDLE
        data_out <= 0; // No pulse initially
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    // Transition to PULSE_RISING state on rising edge
                    state <= PULSE_RISING;
                end else begin
                    // Stay in IDLE state if no rising edge
                    state <= IDLE;
                end
                data_out <= 0; // No pulse in IDLE state
            end
            PULSE_RISING: begin
                if (~data_in) begin
                    // Transition to PULSE_FALLING state on falling edge after rising edge
                    state <= PULSE_FALLING;
                end else begin
                    // Stay in PULSE_RISING state if still high
                    state <= PULSE_RISING;
                end
                data_out <= 0; // No pulse in PULSE_RISING state
            end
            PULSE_FALLING: begin
                // Transition back to IDLE state after falling edge
                state <= IDLE;
                data_out <= 1; // Pulse detected
            end
            default: begin
                state <= IDLE; // Default to IDLE state
                data_out <= 0; // No pulse by default
            end
        endcase
    end
end

endmodule