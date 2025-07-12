module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States for pulse generation
typedef enum logic [1:0] {
    S_RESET,
    S_PULSE_F,
    S_ACTIVE
} pulse_state_t;

// Monitoring states
typedef enum logic [1:0] {
    M_IDLE,
    M_WAIT_PATTERN,
    M_MONITOR_Y,
    M_DONE
} monitor_state_t;

// Registers
pulse_state_t pulse_state;
monitor_state_t monitor_state;
reg [2:0] x_shift;        // Shift register for x input
reg [1:0] y_timeout;      // 2-bit counter for y monitoring
reg g_permanent;          // Permanent g status
reg pattern_detected;     // Flag for 101 pattern detection

// Sequence detection
wire sequence_match = (x_shift == 3'b101);

always @(posedge clk) begin
    if (!resetn) begin
        // Reset all registers
        pulse_state <= S_RESET;
        monitor_state <= M_IDLE;
        f <= 0;
        g <= 0;
        x_shift <= 0;
        y_timeout <= 0;
        g_permanent <= 0;
        pattern_detected <= 0;
    end
    else begin
        // Shift register for x pattern
        x_shift <= {x_shift[1:0], x};

        // Pulse generation FSM
        case (pulse_state)
            S_RESET: begin
                f <= 0;
                pulse_state <= S_PULSE_F;
            end
            S_PULSE_F: begin
                f <= 1;
                pulse_state <= S_ACTIVE;
            end
            S_ACTIVE: begin
                f <= 0;
            end
        endcase

        // Monitoring FSM
        case (monitor_state)
            M_IDLE: begin
                if (pulse_state == S_ACTIVE) begin
                    monitor_state <= M_WAIT_PATTERN;
                end
            end

            M_WAIT_PATTERN: begin
                if (sequence_match) begin
                    monitor_state <= M_MONITOR_Y;
                    g <= 1;
                    y_timeout <= 0;
                end
            end

            M_MONITOR_Y: begin
                if (!g_permanent) begin
                    if (y) begin
                        g_permanent <= 1;
                    end
                    else if (y_timeout == 2'b01) begin
                        g_permanent <= 1;
                        g <= 0;
                    end
                    y_timeout <= y_timeout + 1;
                end
                else begin
                    monitor_state <= M_DONE;
                end
            end

            M_DONE: begin
                // Stay in this state until reset
            end
        endcase
    end
end

endmodule