module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE         = 2'b00, // Waiting for initial 0
        WAIT_RISE    = 2'b01, // Detected 0, waiting for 1
        WAIT_FALL    = 2'b10, // Detected 1, waiting for 0
        PULSE_DETECTED = 2'b11 // Pulse detected, output data_out = 1 this cycle
    } state_t;

    state_t current_state, next_state;

    // FSM sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            data_out <= 1'b0;
        end else begin
            current_state <= next_state;
            // Assert data_out only in PULSE_DETECTED state for one cycle
            data_out <= (next_state == PULSE_DETECTED);
        end
    end

    // FSM combinational logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                // Wait for data_in to be 0 to start detection
                if (data_in == 1'b0)
                    next_state = WAIT_RISE;
                else
                    next_state = IDLE;
            end
            WAIT_RISE: begin
                // Wait for data_in to rise to 1
                if (data_in == 1'b1)
                    next_state = WAIT_FALL;
                else if (data_in == 1'b0)
                    next_state = WAIT_RISE; // stay waiting for rising edge
                else
                    next_state = IDLE; // safety fallback
            end
            WAIT_FALL: begin
                // Wait for data_in to fall back to 0 to complete pulse
                if (data_in == 1'b0)
                    next_state = PULSE_DETECTED;
                else if (data_in == 1'b1)
                    next_state = WAIT_FALL; // still high, wait
                else
                    next_state = IDLE; // safety fallback
            end
            PULSE_DETECTED: begin
                // After output pulse, go back to IDLE and start over
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule