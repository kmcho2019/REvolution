module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States (now properly sized with 3 bits)
typedef enum logic [2:0] {
    RESET       = 3'd0,
    PULSE_F     = 3'd1,
    WAIT_PATTERN = 3'd2,
    MONITOR_Y   = 3'd3,
    FINAL       = 3'd4
} state_t;

state_t current_state, next_state;

// Pattern detection
reg x_prev, pattern_start;
reg timeout_bit;

always @(posedge clk) begin
    if (!resetn) begin
        current_state <= RESET;
        f <= 0;
        g <= 0;
        x_prev <= 0;
        pattern_start <= 0;
        timeout_bit <= 0;
    end else begin
        current_state <= next_state;
        f <= 0;  // Default f=0
        
        case (current_state)
            RESET: begin
                next_state <= PULSE_F;
                g <= 0;
            end
            
            PULSE_F: begin
                f <= 1;
                next_state <= WAIT_PATTERN;
            end
            
            WAIT_PATTERN: begin
                // Detect 1-0-1 pattern
                if (x_prev && !x) 
                    pattern_start <= 1;
                else if (pattern_start && x) begin
                    next_state <= MONITOR_Y;
                    g <= 1;
                    pattern_start <= 0;
                end
                x_prev <= x;
            end
            
            MONITOR_Y: begin
                if (y) begin
                    next_state <= FINAL; // Keep g=1 forever
                end else if (timeout_bit) begin
                    next_state <= FINAL;
                    g <= 0;
                end
                timeout_bit <= ~timeout_bit; // Toggle for 2-cycle timeout
            end
            
            FINAL: begin
                // Outputs maintain their values permanently
                next_state <= FINAL;
            end
        endcase
    end
end

endmodule