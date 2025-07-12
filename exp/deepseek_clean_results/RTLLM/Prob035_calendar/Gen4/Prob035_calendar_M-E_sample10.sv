module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

reg [16:0] total_seconds;  // 17-bit counter (0 to 86399)

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        total_seconds <= 17'd0;
    end else begin
        if (total_seconds == 17'd86399) begin
            total_seconds <= 17'd0;
        end else begin
            total_seconds <= total_seconds + 17'd1;
        end
    end
end

// Decode logic (combinational)
always @(*) begin
    // Seconds = total_seconds % 60
    Secs = total_seconds % 6'd60;
    
    // Minutes = (total_seconds / 60) % 60
    Mins = (total_seconds / 6'd60) % 6'd60;
    
    // Hours = total_seconds / 3600
    Hours = total_seconds / 17'd3600;
end

endmodule