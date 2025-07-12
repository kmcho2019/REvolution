module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
typedef enum logic [1:0] {
    RESET,
    PULSE_F,
    WAIT_FOR_PATTERN,
    MONITOR_Y,
    FINAL
} state_t;

state_t current_state, next_state;

// Pattern detection registers
reg x_prev, pattern_start;

always @(posedge clk) begin
    if (!resetn) begin
        current_state <= RESET;
        f <= 0;
        g <= 0;
        x_prev <= 0;
        pattern_start <= 0;
    end else begin
        // Default outputs
        f <= 0;
        
        case (current_state)
            RESET: begin
                next_state <= PULSE_F;
            end
            
            PULSE_F: begin
                f <= 1;
                next_state <= WAIT_FOR_PATTERN;
            end
            
            WAIT_FOR_PATTERN: begin
                // Detect 1-0-1 pattern
                if (x_prev && !x) 
                    pattern_start <= 1;
                else if (pattern_start && x) begin
                    next_state <= MONITOR_Y;
                    pattern_start <= 0;
                    g <= 1;
                end
                x_prev <= x;
            end
            
            MONITOR_Y: begin
                if (y) begin
                    next_state <= FINAL; // Keep g=1 forever
                end else if (x_prev) begin // Using x_prev as 1-cycle timeout
                    next_state <= FINAL;
                    g <= 0;
                end
                x_prev <= ~x_prev; // Toggle for timeout
            end
            
            FINAL: begin
                // Outputs maintain their values permanently
                next_state <= FINAL;
            end
        endcase
        
        current_state <= next_state;
    end
end

endmodule