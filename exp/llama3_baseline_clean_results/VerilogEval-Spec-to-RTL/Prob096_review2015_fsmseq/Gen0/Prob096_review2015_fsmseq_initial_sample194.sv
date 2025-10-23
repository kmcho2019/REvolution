module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states for the FSM
typedef enum logic [2:0] {
    IDLE,     // Initial state
    DETECT_1, // Detected first '1'
    DETECT_11, // Detected '11'
    DETECT_110, // Detected '110'
    DETECT_1101 // Detected '1101'
} state_t;

state_t current_state;

// Initialize start_shifting to 0
initial start_shifting = 0;

// Main FSM logic
always @(posedge clk) begin
    if (reset) begin
        // Reset to initial state
        current_state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data) begin
                    // Move to detect first '1' state
                    current_state <= DETECT_1;
                end
            end
            DETECT_1: begin
                if (data) begin
                    // Move to detect '11' state
                    current_state <= DETECT_11;
                end else begin
                    // Reset to IDLE state if '0' is received
                    current_state <= IDLE;
                end
            end
            DETECT_11: begin
                if (~data) begin
                    // Move to detect '110' state
                    current_state <= DETECT_110;
                end else begin
                    // Reset to DETECT_1 state if '1' is received
                    current_state <= DETECT_1;
                end
            end
            DETECT_110: begin
                if (data) begin
                    // Move to detect '1101' state
                    current_state <= DETECT_1101;
                end else begin
                    // Reset to IDLE state if '0' is received
                    current_state <= IDLE;
                end
            end
            DETECT_1101: begin
                // Set start_shifting to 1
                start_shifting <= 1;
            end
            default: begin
                current_state <= IDLE;
            end
        endcase
    end
end

endmodule