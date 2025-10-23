module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Secs   // 0-59
);

// Seconds counter: increments every clock cycle, wraps at 59, synchronous reset
always @(posedge CLK) begin
    if (RST) begin
        Secs <= 6'd0;
    end else begin
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
        end else begin
            Secs <= Secs + 6'd1;
        end
    end
end

// Minutes enable when seconds wrap (Secs == 59)
wire mins_enable = (Secs == 6'd59);

// Minutes counter: increments only when secs wrap, wraps at 59, synchronous reset
always @(posedge CLK) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (mins_enable) begin
        if (Mins == 6'd59) begin
            Mins <= 6'd0;
        end else begin
            Mins <= Mins + 6'd1;
        end
    end
    // else hold value implicitly
end

// Hours enable when minutes and seconds wrap (Mins == 59 && Secs == 59)
wire hours_enable = mins_enable && (Mins == 6'd59);

// Hours counter: increments only when mins and secs wrap, wraps at 23, synchronous reset
always @(posedge CLK) begin
    if (RST) begin
        Hours <= 5'd0;
    end else if (hours_enable) begin
        if (Hours == 5'd23) begin
            Hours <= 5'd0;
        end else begin
            Hours <= Hours + 5'd1;
        end
    end
    // else hold value implicitly
end

endmodule