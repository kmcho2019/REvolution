module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 5 bits sufficient for 0-23
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Continuous assignments for rollover conditions
wire sec_max = (Secs == 6'd59);
wire min_max = (Mins == 6'd59);
wire hour_max = (Hours == 5'd23);

wire sec_roll = sec_max;
wire min_roll = sec_max && min_max;
wire hour_roll = sec_max && min_max && hour_max;

// Internal next value calculations
reg [5:0] next_sec;
reg [5:0] next_min;
reg [4:0] next_hour;

always @(*) begin
    // Seconds logic
    next_sec = sec_roll ? 6'd0 : (Secs + 6'd1);
    
    // Minutes logic
    if (sec_roll) begin
        next_min = min_roll ? 6'd0 : (Mins + 6'd1);
    end else begin
        next_min = Mins;
    end
    
    // Hours logic
    if (min_roll && sec_roll) begin
        next_hour = hour_roll ? 5'd0 : (Hours + 5'd1);
    end else begin
        next_hour = Hours;
    end
end

// Sequential update block
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