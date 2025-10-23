module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Constants for maximum values
localparam SEC_MAX = 6'd59;
localparam MIN_MAX = 6'd59;
localparam HOUR_MAX = 6'd23;

// Internal enable signals
wire sec_enable = 1'b1;  // Always counting
wire min_enable = (Secs == SEC_MAX);
wire hour_enable = (Mins == MIN_MAX) & min_enable;

// Next state values
wire [5:0] next_sec = (Secs == SEC_MAX) ? 6'd0 : Secs + 1;
wire [5:0] next_min = (Mins == MIN_MAX) ? 6'd0 : Mins + 1;
wire [5:0] next_hour = (Hours == HOUR_MAX) ? 6'd0 : Hours + 1;

// Seconds counter (always active)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else begin
        Secs <= next_sec;
    end
end

// Minutes counter (only updates when seconds roll over)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (min_enable) begin
        Mins <= next_min;
    end
end

// Hours counter (only updates when minutes roll over)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if (hour_enable) begin
        Hours <= next_hour;
    end
end

endmodule