module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

// Define the states of the FSM
typedef enum logic [1:0] {
    IDLE,
    RISE_DETECTED,
    FALL_DETECTED
} state_t;

// Current state of the FSM
state_t current_state;

// Previous value of 'a'
reg prev_a;

// Initialize the FSM to the IDLE state and previous value of 'a' to 0
initial begin
    current_state = IDLE;
    prev_a = 1'b0;
end

// Sequential logic to handle state transitions
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the FSM to the IDLE state
        current_state <= IDLE;
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Store the current value of 'a'
        reg current_a = a;

        case (current_state)
            IDLE: begin
                // Check for rising or falling edge
                if (current_a &&!prev_a) begin
                    // Rising edge detected
                    current_state <= RISE_DETECTED;
                end else if (!current_a && prev_a) begin
                    // Falling edge detected
                    current_state <= FALL_DETECTED;
                end else begin
                    // No edge detected
                    current_state <= IDLE;
                end
            end
            RISE_DETECTED: begin
                // Pulse the rise signal for one clock cycle
                rise <= 1'b1;
                current_state <= IDLE;
            end
            FALL_DETECTED: begin
                // Pulse the down signal for one clock cycle
                down <= 1'b1;
                current_state <= IDLE;
            end
            default: begin
                // Invalid state, reset to IDLE
                current_state <= IDLE;
            end
        endcase

        // Update the previous value of 'a'
        prev_a <= current_a;

        // Reset the output signals if no edge is detected
        if (current_state == IDLE) begin
            rise <= 1'b0;
            down <= 1'b0;
        end
    end
end

endmodule