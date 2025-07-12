module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Single counter covering 24 hours (86400 seconds)
reg [16:0] total_seconds;  // 17 bits needed for 86400 (2^17=131072)

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        total_seconds <= 17'd0;
    end else begin
        if (total_seconds == 17'd86399)  // 23:59:59
            total_seconds <= 17'd0;
        else
            total_seconds <= total_seconds + 1;
    end
end

// Combinational decoding of time components
always @(*) begin
    // Seconds = total_seconds % 60
    Secs = total_seconds % 6'd60;
    
    // Minutes = (total_seconds / 60) % 60
    Mins = (total_seconds / 6'd60) % 6'd60;
    
    // Hours = total_seconds / 3600
    Hours = total_seconds / 17'd3600;
end

endmodule