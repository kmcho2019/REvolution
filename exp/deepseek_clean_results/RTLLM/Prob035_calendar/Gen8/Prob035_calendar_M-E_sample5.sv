module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// 17-bit counter (2^17 = 131072 > 86400)
reg [16:0] total_seconds;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        total_seconds <= 17'd0;
    end else begin
        // Increment counter, wrapping at 86400 (24*60*60)
        total_seconds <= (total_seconds == 17'd86399) ? 17'd0 : total_seconds + 17'd1;
    end
end

// Continuous assignments to extract time components
always @(*) begin
    // Seconds = total_seconds % 60
    Secs = total_seconds % 6'd60;
    
    // Minutes = (total_seconds / 60) % 60
    Mins = (total_seconds / 6'd60) % 6'd60;
    
    // Hours = total_seconds / 3600
    Hours = total_seconds / 17'd3600;
end

endmodule