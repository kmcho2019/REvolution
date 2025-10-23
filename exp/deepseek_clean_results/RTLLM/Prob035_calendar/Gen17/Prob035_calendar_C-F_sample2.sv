module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Parameterized constants
parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 5'd23;

// Current rollover conditions
wire sec_roll = (Secs == SEC_MAX);
wire min_roll = (Mins == MIN_MAX);
wire hour_roll = (Hours == HOUR_MAX);

// Next state calculations (parallel)
wire [5:0] next_sec = sec_roll ? 6'd0 : (Secs + 6'd1);
wire [5:0] next_min = (sec_roll && min_roll) ? 6'd0 : 
                     (sec_roll ? (Mins + 6'd1) : Mins);
wire [4:0] next_hour = (sec_roll && min_roll && hour_roll) ? 5'd0 :
                      ((sec_roll && min_roll) ? (Hours + 5'd1) : Hours);

// Sequential updates
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        Secs <= next_sec;
        // Only update minutes when seconds roll over
        if (sec_roll) Mins <= next_min;
        // Only update hours when minutes roll over (which requires sec_roll)
        if (sec_roll && min_roll) Hours <= next_hour;
    end
end

endmodule