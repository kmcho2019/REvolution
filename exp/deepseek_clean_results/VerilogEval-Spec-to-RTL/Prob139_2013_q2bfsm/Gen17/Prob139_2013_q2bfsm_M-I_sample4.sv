module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
typedef enum logic [1:0] {
    RESET,
    PULSE_F,
    MONITOR_X,
    MONITOR_Y
} state_t;

state_t current_state, next_state;

// Pattern detection shift register
reg [2:0] x_pattern;
reg [1:0] timeout_counter;
reg g_permanent;

// State transition logic
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= RESET;
        x_pattern <= 3'b0;
        timeout_counter <= 2'b0;
        g_permanent <= 1'b0;
        g <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Shift register for x pattern detection
        x_pattern <= {x_pattern[1:0], x};
        
        // Timeout counter for y monitoring
        if (current_state == MONITOR_Y && !g_permanent) begin
            timeout_counter <= timeout_counter - 1;
        end
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        RESET: next_state = PULSE_F;
        
        PULSE_F: next_state = MONITOR_X;
        
        MONITOR_X: begin
            if (x_pattern == 3'b101) begin
                next_state = MONITOR_Y;
            end else begin
                next_state = MONITOR_X;
            end
        end
        
        MONITOR_Y: next_state = MONITOR_Y; // Stay here until reset
        
        default: next_state = RESET;
    endcase
end

// Output logic
always @(posedge clk) begin
    if (!resetn) begin
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        // f output (single pulse)
        f <= (current_state == PULSE_F);
        
        // g output control
        if (current_state == MONITOR_X && x_pattern == 3'b101) begin
            g <= 1'b1;
            timeout_counter <= 2'b10; // Initialize 2-cycle timeout
        end
        else if (current_state == MONITOR_Y && !g_permanent) begin
            if (y) begin
                g_permanent <= 1'b1;
            end
            else if (timeout_counter == 2'b00) begin
                g <= 1'b0;
                g_permanent <= 1'b1;
            end
        end
    end
end

endmodule