module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the state machine using binary encoding
enum logic [1:0] {
    IDLE = 2'b00,
    PULSE_RISING = 2'b01,
    PULSE_FALLING = 2'b10
} state, next_state;

// Clock gating logic
reg clk_gate;
always @(*) begin
    if (data_in == 1'b0 || data_in == 1'b1) begin
        // If data_in is stable (either 0 or 1), gate the clock
        clk_gate = 1'b0;
    end else begin
        // Otherwise, enable the clock
        clk_gate = 1'b1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Initial state: IDLE
        data_out <= 0; // No pulse initially
    end else if (clk_gate) begin // Clock gated state machine
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