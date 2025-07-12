module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Main states
typedef enum logic [1:0] {
    RESET_STATE,
    PULSE_F_STATE,
    MONITOR_X_STATE,
    MONITOR_Y_STATE
} state_t;

// Pattern cache for x input
typedef struct packed {
    logic [2:0] history;
    logic full;
} pattern_cache_t;

// Timeout controller
typedef struct packed {
    logic [1:0] count;
    logic active;
} timeout_t;

state_t current_state;
pattern_cache_t x_cache;
timeout_t y_timeout;
logic g_permanent;

always @(posedge clk) begin
    if (!resetn) begin
        // Reset all components
        current_state <= RESET_STATE;
        f <= 1'b0;
        g <= 1'b0;
        x_cache <= '{history: 3'b0, full: 1'b0};
        y_timeout <= '{count: 2'b0, active: 1'b0};
        g_permanent <= 1'b0;
    end
    else begin
        // Update x pattern cache
        x_cache.history <= {x_cache.history[1:0], x};
        if (!x_cache.full) begin
            x_cache.full <= (x_cache.history[1] & x); // Simple fill detection
        end

        case (current_state)
            RESET_STATE: begin
                // Wait in reset state until reset is released
                f <= 1'b0;
                g <= 1'b0;
                current_state <= PULSE_F_STATE;
            end

            PULSE_F_STATE: begin
                // Generate single-cycle f pulse
                f <= 1'b1;
                current_state <= MONITOR_X_STATE;
            end

            MONITOR_X_STATE: begin
                f <= 1'b0;
                
                // Check for 101 pattern when cache is full
                if (x_cache.full && (x_cache.history == 3'b101)) begin
                    g <= 1'b1;
                    y_timeout <= '{count: 2'b10, active: 1'b1};
                    current_state <= MONITOR_Y_STATE;
                end
            end

            MONITOR_Y_STATE: begin
                if (!g_permanent) begin
                    if (y) begin
                        // y detected - make g permanent
                        g_permanent <= 1'b1;
                    end
                    else if (y_timeout.active) begin
                        // Decrement timeout counter
                        y_timeout.count <= y_timeout.count - 1;
                        
                        if (y_timeout.count == 2'b00) begin
                            // Timeout expired - set g to 0 permanently
                            g <= 1'b0;
                            g_permanent <= 1'b1;
                        end
                    end
                end
            end
        endcase
    end
end

endmodule