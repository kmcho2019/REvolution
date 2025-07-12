module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// 17-bit counter can count up to 24 hours (86400 seconds needs 17 bits)
reg [16:0] total_seconds;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        total_seconds <= 17'd0;
    end else begin
        // Increment counter every clock cycle (assuming 1Hz clock)
        // For higher frequency clocks, add a prescaler
        if (total_seconds < 17'd86399)  // 23:59:59
            total_seconds <= total_seconds + 1;
        else
            total_seconds <= 17'd0;
    end
end

// Conversion from total seconds to HH:MM:SS
always @(*) begin
    // Hours = total_seconds / 3600
    Hours = total_seconds / 17'd3600;
    
    // Minutes = (total_seconds % 3600) / 60
    Mins = (total_seconds % 17'd3600) / 17'd60;
    
    // Seconds = total_seconds % 60
    Secs = total_seconds % 17'd60;
end

endmodule