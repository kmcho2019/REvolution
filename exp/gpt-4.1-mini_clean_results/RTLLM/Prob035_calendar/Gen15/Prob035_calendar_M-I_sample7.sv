module calendar (
    input  wire       CLK,
    input  wire       RST,       // synchronous active-high reset
    output reg  [5:0] Hours,     // 0-23 stored internally as 5-bit, output 6-bit
    output reg  [5:0] Mins,      // 0-59
    output reg  [5:0] Secs       // 0-59
);

// Internal signals
wire secs_wrap = (Secs == 6'd59);
wire mins_wrap = (Mins == 6'd59);
wire hours_wrap = (Hours == 6'd23);

// Seconds counter: increments every clock cycle, wraps at 59
always @(posedge CLK) begin
    if (RST) begin
        Secs <= 6'd0;
    end else begin
        if (secs_wrap)
            Secs <= 6'd0;
        else
            Secs <= Secs + 6'd1;
    end
end

// Minutes and Hours counter combined: increments when seconds wrap
always @(posedge CLK) begin
    if (RST) begin
        Mins  <= 6'd0;
        Hours <= 6'd0;
    end else if (secs_wrap) begin
        if (mins_wrap) begin
            Mins <= 6'd0;
            if (hours_wrap)
                Hours <= 6'd0;
            else
                Hours <= Hours + 6'd1;
        end else begin
            Mins <= Mins + 6'd1;
            Hours <= Hours; // hold current value
        end
    end else begin
        Mins  <= Mins;  // hold current values
        Hours <= Hours;
    end
end

endmodule