module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Parameterized constants
parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 6'd23;

// Rollover conditions
wire sec_roll = (Secs == SEC_MAX);
wire min_roll = (Mins == MIN_MAX) && sec_roll;
wire hour_roll = (Hours == HOUR_MAX) && min_roll;

// Seconds counter with clock gating
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else begin
        if (Secs != SEC_MAX)
            Secs <= Secs + 1;
        else
            Secs <= 0;
    end
end

// Minutes counter with enable
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (sec_roll) begin
        if (Mins != MIN_MAX)
            Mins <= Mins + 1;
        else
            Mins <= 0;
    end
end

// Hours counter with enable
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if (min_roll) begin
        if (Hours != HOUR_MAX)
            Hours <= Hours + 1;
        else
            Hours <= 0;
    end
end

endmodule