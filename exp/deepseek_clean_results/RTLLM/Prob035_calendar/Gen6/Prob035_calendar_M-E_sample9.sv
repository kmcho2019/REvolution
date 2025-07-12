module calendar (
    input CLK,
    input RST,
    output [5:0] Hours,
    output [5:0] Mins,
    output [5:0] Secs
);

// 17-bit counter (2^17 = 131072 > 86400 seconds in a day)
reg [16:0] total_seconds;

// Counter logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        total_seconds <= 17'd0;
    end else begin
        if (total_seconds == 17'd86399)  // 23:59:59
            total_seconds <= 17'd0;
        else
            total_seconds <= total_seconds + 17'd1;
    end
end

// Time decoding logic
wire [16:0] total_mins = total_seconds / 17'd60;
wire [16:0] total_hours = total_seconds / 17'd3600;

assign Secs = total_seconds % 17'd60;          // Seconds (0-59)
assign Mins = total_mins % 17'd60;             // Minutes (0-59)
assign Hours = total_hours % 17'd24;           // Hours (0-23)

endmodule