module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Pattern detection registers
reg [2:0] x_pattern;  // Stores last 3 x values
reg pattern_matched;   // Flag when 1-0-1 is detected
reg y_timeout;         // Flag when y monitoring times out
reg g_permanent;       // Flag for permanent g state

// Control counters
reg f_pulse_done;      // Flag when f pulse is complete
reg [1:0] y_timer;     // Counts cycles in y monitoring

always @(posedge clk) begin
    if (!resetn) begin
        // Reset all registers
        f <= 0;
        g <= 0;
        x_pattern <= 0;
        pattern_matched <= 0;
        y_timeout <= 0;
        g_permanent <= 0;
        f_pulse_done <= 0;
        y_timer <= 0;
    end
    else begin
        // Shift in new x value
        x_pattern <= {x_pattern[1:0], x};
        
        // Check for 1-0-1 pattern
        pattern_matched <= (x_pattern == 3'b101);
        
        // f pulse generation (one cycle after reset)
        if (!f_pulse_done) begin
            f <= 1;
            f_pulse_done <= 1;
        end
        else begin
            f <= 0;
        end
        
        // g control logic
        if (!g_permanent) begin
            if (pattern_matched) begin
                g <= 1;
                y_timer <= 0;
            end
            else if (g && !y_timeout) begin
                // Monitoring y for 2 cycles
                if (y) begin
                    g_permanent <= 1;
                end
                else if (y_timer == 2'b01) begin
                    y_timeout <= 1;
                    g <= 0;
                    g_permanent <= 1;
                end
                else begin
                    y_timer <= y_timer + 1;
                end
            end
        end
    end
end

endmodule