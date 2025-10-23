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
    IDLE,      // Initial state (reset)
    PULSE_F,   // Generate f pulse
    MONITOR    // Monitor x and y patterns
} state_t;

state_t state;
reg [2:0] x_shift;    // Shift register for x pattern
reg [1:0] y_timer;     // Timer for y monitoring
reg g_permanent;       // Flag for permanent g state

always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        f <= 0;
        g <= 0;
        x_shift <= 3'b0;
        y_timer <= 2'b0;
        g_permanent <= 0;
    end else begin
        // Update x shift register
        x_shift <= {x_shift[1:0], x};
        
        case (state)
            IDLE: begin
                state <= PULSE_F;
                f <= 1;
            end
            
            PULSE_F: begin
                state <= MONITOR;
                f <= 0;
            end
            
            MONITOR: begin
                if (!g_permanent) begin
                    // Check for 1-0-1 pattern
                    if (x_shift == 3'b101) begin
                        g <= 1;
                        y_timer <= 2'b0;  // Start y monitoring
                    end
                    
                    // If g is set, monitor y
                    if (g) begin
                        if (y) begin
                            g_permanent <= 1;  // Keep g=1 permanently
                        end else if (y_timer == 2'b10) begin
                            g <= 0;
                            g_permanent <= 1;  // Keep g=0 permanently
                        end else begin
                            y_timer <= y_timer + 1;
                        end
                    end
                end
            end
        endcase
    end
end

endmodule