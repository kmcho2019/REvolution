module calendar(
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Next state variables
reg [4:0] next_hours;
reg [5:0] next_mins;
reg [5:0] next_secs;

// Rollover flags
wire sec_rollover = (Secs == 6'd59);
wire min_rollover = (Mins == 6'd59) & sec_rollover;
wire hour_rollover = (Hours == 5'd23) & min_rollover;

// Combinational next-state logic
always @(*) begin
    // Seconds logic
    next_secs = sec_rollover ? 6'd0 : (Secs + 6'd1);
    
    // Minutes logic
    if (min_rollover)
        next_mins = 6'd0;
    else if (sec_rollover)
        next_mins = Mins + 6'd1;
    else
        next_mins = Mins;
    
    // Hours logic
    if (hour_rollover)
        next_hours = 5'd0;
    else if (min_rollover)
        next_hours = Hours + 5'd1;
    else
        next_hours = Hours;
end

// Sequential state update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        Hours <= next_hours;
        Mins <= next_mins;
        Secs <= next_secs;
    end
end

endmodule