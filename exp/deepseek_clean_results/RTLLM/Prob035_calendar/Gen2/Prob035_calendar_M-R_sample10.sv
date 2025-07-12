module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Consolidated timekeeping in single always block
always @(posedge CLK or posedge RST) begin
    // Temporary variables for next state values
    reg [5:0] next_secs;
    reg [5:0] next_mins;
    reg [5:0] next_hours;
    
    if (RST) begin
        // Reset all counters
        next_secs = 6'd0;
        next_mins = 6'd0;
        next_hours = 6'd0;
    end else begin
        // Default case: maintain current values
        next_secs = Secs;
        next_mins = Mins;
        next_hours = Hours;
        
        // Seconds logic
        if (Secs == 6'd59) begin
            next_secs = 6'd0;
            // Minutes logic (only when seconds roll over)
            if (Mins == 6'd59) begin
                next_mins = 6'd0;
                // Hours logic (only when minutes roll over)
                if (Hours == 6'd23) begin
                    next_hours = 6'd0;
                end else begin
                    next_hours = Hours + 6'd1;
                end
            end else begin
                next_mins = Mins + 6'd1;
            end
        end else begin
            next_secs = Secs + 6'd1;
        end
    end
    
    // Update outputs
    Secs <= next_secs;
    Mins <= next_mins;
    Hours <= next_hours;
end

endmodule