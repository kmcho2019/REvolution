module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours, // 0-23 (6 bits for convenience)
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Secs   // 0-59
);

// Total seconds in a day: 24*3600 = 86400, so 0..86399 count
reg [16:0] total_seconds; // Enough bits to count up to 86399 (2^17=131072)

// Constants for division
localparam integer SECS_PER_DAY = 86400;
localparam integer SECS_PER_HOUR = 3600;
localparam integer SECS_PER_MIN = 60;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        total_seconds <= 17'd0;
        Hours <= 6'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        if (total_seconds == SECS_PER_DAY - 1)
            total_seconds <= 17'd0;
        else
            total_seconds <= total_seconds + 17'd1;

        // Combinational arithmetic from total_seconds
        // Hours = total_seconds / 3600
        Hours <= total_seconds / SECS_PER_HOUR;

        // Minutes = (total_seconds % 3600) / 60
        Mins <= (total_seconds % SECS_PER_HOUR) / SECS_PER_MIN;

        // Seconds = total_seconds % 60
        Secs <= total_seconds % SECS_PER_MIN;
    end
end

endmodule