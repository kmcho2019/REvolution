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

// Combinational next-state logic
wire [5:0] next_sec = (Secs == SEC_MAX) ? 6'd0 : (Secs + 6'd1);
wire sec_roll = (Secs == SEC_MAX);

wire [5:0] next_min = (sec_roll && (Mins == MIN_MAX)) ? 6'd0 : 
                     (sec_roll ? (Mins + 6'd1) : Mins);
wire min_roll = sec_roll && (Mins == MIN_MAX);

wire [4:0] next_hour = (min_roll && (Hours == HOUR_MAX)) ? 5'd0 : 
                      (min_roll ? (Hours + 5'd1) : Hours);

// Sequential update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        Secs <= next_sec;
        Mins <= next_min;
        Hours <= next_hour;
    end
end

endmodule