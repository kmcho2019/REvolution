module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 0-23 (5 bits)
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SEC = 59;
localparam MAX_MIN = 59;
localparam MAX_HOUR = 23;

// Next state values
reg [5:0] next_sec;
reg [5:0] next_min;
reg [4:0] next_hour;

// Parallel rollover detection
wire sec_max = (Secs == MAX_SEC);
wire min_max = (Mins == MAX_MIN);
wire hour_max = (Hours == MAX_HOUR);

always @(*) begin
    // Seconds logic (always updates)
    next_sec = sec_max ? 6'd0 : (Secs + 1);

    // Minutes logic (only updates when seconds roll over)
    if (sec_max) begin
        next_min = min_max ? 6'd0 : (Mins + 1);
    end else begin
        next_min = Mins;
    end

    // Hours logic (only updates when minutes and seconds roll over)
    if (sec_max & min_max) begin
        next_hour = hour_max ? 5'd0 : (Hours + 1);
    end else begin
        next_hour = Hours;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        Secs <= next_sec;
        Mins <= next_min;
        Hours <= next_hour;
    end
end

endmodule