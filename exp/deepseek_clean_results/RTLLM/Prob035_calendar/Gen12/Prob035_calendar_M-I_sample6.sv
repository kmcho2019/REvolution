module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Parameters for maximum values
parameter MAX_SEC = 6'd59;
parameter MAX_MIN = 6'd59;
parameter MAX_HOUR = 5'd23;

// Internal signals
reg sec_rollover_q, min_rollover_q;
wire sec_rollover = (Secs == MAX_SEC);
wire min_rollover = (Mins == MAX_MIN) & sec_rollover;
wire hour_rollover = (Hours[4:0] == MAX_HOUR) & min_rollover;

// Next state signals
reg [5:0] next_sec;
reg [5:0] next_min;
reg [5:0] next_hour;

// Rollover pipeline registers
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        sec_rollover_q <= 1'b0;
        min_rollover_q <= 1'b0;
    end else begin
        sec_rollover_q <= sec_rollover;
        min_rollover_q <= min_rollover;
    end
end

// Combinational next-state logic
always @* begin
    // Default next states
    next_sec = Secs + 6'd1;
    next_min = Mins;
    next_hour = Hours;
    
    // Seconds logic
    if (sec_rollover) begin
        next_sec = 6'd0;
    end
    
    // Minutes logic (only evaluated when needed)
    if (sec_rollover_q) begin
        next_min = min_rollover_q ? 6'd0 : Mins + 6'd1;
    end
    
    // Hours logic (only evaluated when needed)
    if (min_rollover_q) begin
        next_hour = hour_rollover ? 6'd0 : {1'b0, Hours[4:0] + 5'd1};
    end
end

// Sequential update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        Secs <= next_sec;
        Mins <= next_min;
        Hours <= next_hour;
    end
end

endmodule