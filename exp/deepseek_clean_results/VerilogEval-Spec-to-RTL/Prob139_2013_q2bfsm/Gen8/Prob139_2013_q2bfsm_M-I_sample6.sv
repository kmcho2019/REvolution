module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Main FSM states
typedef enum logic [2:0] {
    S_RESET,
    S_PULSE_F,
    S_WAIT_PATTERN,
    S_PATTERN_DETECTED,
    S_MONITOR_Y,
    S_G_HIGH,
    S_G_LOW
} state_t;

// Registers
state_t state;
reg [1:0] x_shift;        // 2-bit shift register for x input
reg [1:0] cycle_count;    // Counter for pattern detection
reg [1:0] y_timeout;      // 2-bit counter for y monitoring

always @(posedge clk) begin
    if (!resetn) begin
        state <= S_RESET;
        f <= 0;
        g <= 0;
        x_shift <= 0;
        cycle_count <= 0;
        y_timeout <= 0;
    end
    else begin
        // Default outputs
        f <= 0;
        
        case (state)
            S_RESET: begin
                state <= S_PULSE_F;
            end
            
            S_PULSE_F: begin
                f <= 1;
                state <= S_WAIT_PATTERN;
                cycle_count <= 0;
            end
            
            S_WAIT_PATTERN: begin
                x_shift <= {x_shift[0], x};
                cycle_count <= cycle_count + 1;
                
                // Check for 1-0-1 pattern after 3 cycles
                if (cycle_count == 2 && x_shift == 2'b10 && x == 1'b1) begin
                    state <= S_PATTERN_DETECTED;
                end
                else if (cycle_count == 2) begin
                    cycle_count <= 0;
                end
            end
            
            S_PATTERN_DETECTED: begin
                g <= 1;
                y_timeout <= 0;
                state <= S_MONITOR_Y;
            end
            
            S_MONITOR_Y: begin
                if (y) begin
                    state <= S_G_HIGH;
                end
                else if (y_timeout == 1) begin
                    state <= S_G_LOW;
                end
                y_timeout <= y_timeout + 1;
            end
            
            S_G_HIGH: begin
                // Maintain g=1 permanently
                g <= 1;
            end
            
            S_G_LOW: begin
                // Maintain g=0 permanently
                g <= 0;
            end
        endcase
    end
end

endmodule