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

// Rollover conditions
wire sec_roll = (Secs == SEC_MAX);
wire min_roll = (Mins == MIN_MAX) && sec_roll;
wire hour_roll = (Hours == HOUR_MAX) && min_roll;

// Seconds counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else begin
        Secs <= sec_roll ? 6'd0 : Secs + 6'd1;
    end
end

// Minutes counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (sec_roll) begin
        Mins <= min_roll ? 6'd0 : Mins + 6'd1;
    end
end

// Hours counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else if (min_roll) begin
        Hours <= hour_roll ? 5'd0 : Hours + 5'd1;
    end
end

endmodule