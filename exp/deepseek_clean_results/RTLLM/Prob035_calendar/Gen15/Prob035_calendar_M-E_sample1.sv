module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Constants
localparam MAX_SEC = 6'd59;
localparam MAX_MIN = 6'd59;
localparam MAX_HOUR = 6'd23;

// Internal state registers
reg [5:0] next_sec, next_min, next_hour;
wire sec_roll = (Secs == MAX_SEC);
wire min_roll = (Mins == MAX_MIN) & sec_roll;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Parallel next state computation
        next_sec = Secs + 1;
        next_min = Mins + (sec_roll ? 1 : 0);
        next_hour = Hours + (min_roll ? 1 : 0);

        // Apply rollover conditions
        Secs <= (next_sec > MAX_SEC) ? 6'd0 : next_sec;
        Mins <= (next_min > MAX_MIN) ? 6'd0 : next_min;
        Hours <= (next_hour > MAX_HOUR) ? 6'd0 : next_hour;
    end
end

endmodule