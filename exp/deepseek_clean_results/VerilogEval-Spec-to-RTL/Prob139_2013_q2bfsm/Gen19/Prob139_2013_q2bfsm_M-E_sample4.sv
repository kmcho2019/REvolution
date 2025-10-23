module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Shift register for pattern detection and timeout tracking
reg [3:0] pattern_reg;  // [2:0] for x pattern, [3] for timeout flag
reg f_pulsed;
reg g_latched;

always @(posedge clk) begin
    if (!resetn) begin
        // Reset state
        pattern_reg <= 4'b0;
        f <= 0;
        f_pulsed <= 0;
        g <= 0;
        g_latched <= 0;
    end else begin
        // Handle f pulse (one cycle after reset)
        if (!f_pulsed) begin
            f <= 1;
            f_pulsed <= 1;
        end else begin
            f <= 0;
        end

        // Shift in new x value (unless we're in timeout mode)
        if (!pattern_reg[3]) begin
            pattern_reg <= {pattern_reg[2:0], x};
            
            // Check for 101 pattern in bits [2:0]
            if (pattern_reg[2:0] == 3'b101) begin
                pattern_reg[3] <= 1;  // Set timeout flag
                g <= 1;             // Set g when pattern detected
            end
        end 
        // Timeout handling (pattern_reg[3] is set)
        else begin
            // Shift in y values for two cycles
            if (pattern_reg[1:0] != 2'b11) begin
                pattern_reg <= {1'b1, pattern_reg[2:1], y};
                
                // Check if we got y=1 during timeout
                if (y) begin
                    g_latched <= 1;  // Permanent g=1
                end
            end 
            // After two cycles, finalize g value
            else if (pattern_reg[1:0] == 2'b11) begin
                if (!g_latched) begin
                    g <= 0;  // Permanent g=0 if no y=1 detected
                end
            end
        end
    end
end

endmodule