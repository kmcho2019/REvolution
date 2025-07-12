module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SEC = 6'd59;
localparam MAX_MIN = 6'd59;
localparam MAX_HOUR = 6'd23;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset all counters
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Calculate next values using blocking assignments
        reg [5:0] next_sec = Secs + 1;
        reg [5:0] next_min = Mins;
        reg [5:0] next_hour = Hours;

        // Seconds counter logic
        if (Secs == MAX_SEC) begin
            next_sec = 6'd0;
            // Minutes counter logic
            next_min = (Mins == MAX_MIN) ? 6'd0 : Mins + 1;
            
            // Hours counter logic
            if (Mins == MAX_MIN) begin
                next_hour = (Hours == MAX_HOUR) ? 6'd0 : Hours + 1;
            end
        end

        // Update all registers with non-blocking assignments
        Secs <= next_sec;
        Mins <= next_min;
        Hours <= next_hour;
    end
end

endmodule