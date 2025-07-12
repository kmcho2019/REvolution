module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Secs   // 0-59
);

// Seconds counter: increments every clock cycle, wraps from 59 to 0
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else if (Secs == 6'd59) begin
        Secs <= 6'd0;
    end else begin
        Secs <= Secs + 6'd1;
    end
end

wire min_inc = (Secs == 6'd59);             // Enable signal for minutes increment
wire hour_inc = (Mins == 6'd59) && min_inc; // Enable signal for hours increment

// Minutes counter: increments only when seconds roll over from 59 to 0
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (min_inc) begin
        if (Mins == 6'd59)
            Mins <= 6'd0;
        else
            Mins <= Mins + 6'd1;
    end
end

// Hours counter: increments only when minutes and seconds both roll over
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else if (hour_inc) begin
        if (Hours == 5'd23)
            Hours <= 5'd0;
        else
            Hours <= Hours + 5'd1;
    end
end

endmodule