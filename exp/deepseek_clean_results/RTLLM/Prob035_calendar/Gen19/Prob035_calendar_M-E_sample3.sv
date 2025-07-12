module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Internal signals (next state)
reg [5:0] next_sec;
reg [5:0] next_min;
reg [4:0] next_hour; // Only need 5 bits for 0-23

always @(posedge CLK) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Calculate next second value
        next_sec = Secs + 1;
        
        // Calculate minute increment (only if seconds roll over)
        next_min = (next_sec >= 6'd60) ? Mins + 1 : Mins;
        
        // Calculate hour increment (only if minutes roll over)
        next_hour = (next_min >= 6'd60) ? Hours[4:0] + 1 : Hours[4:0];
        
        // Apply rollover with parallel checks
        Secs <= (next_sec >= 6'd60) ? 6'd0 : next_sec;
        Mins <= (next_min >= 6'd60) ? 6'd0 : next_min;
        Hours <= {1'b0, (next_hour >= 5'd24) ? 5'd0 : next_hour};
    end
end

endmodule