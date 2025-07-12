module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 5 bits for 0-23
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Parameterized constants
parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 5'd23;

// Next state signals
wire [5:0] next_sec;
wire [5:0] next_min;
wire [4:0] next_hour;

// Rollover conditions
wire sec_roll = (Secs == SEC_MAX);
wire min_roll = (Mins == MIN_MAX) && sec_roll;
wire hour_roll = (Hours == HOUR_MAX) && min_roll;

// Next state calculations
assign next_sec = RST ? 6'd0 : (sec_roll ? 6'd0 : Secs + 6'd1);
assign next_min = RST ? 6'd0 : (sec_roll ? (min_roll ? 6'd0 : Mins + 6'd1) : Mins);
assign next_hour = RST ? 5'd0 : (min_roll ? (hour_roll ? 5'd0 : Hours + 5'd1) : Hours);

// Sequential updates
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