module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 requires 5 bits
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

// Seconds and Minutes combined: seconds increment every cycle; minutes increment on seconds overflow
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
    end else begin
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
            if (Mins == 6'd59)
                Mins <= 6'd0;
            else
                Mins <= Mins + 6'd1;
        end else begin
            Secs <= Secs + 6'd1;
            Mins <= Mins;
        end
    end
end

// Hours counter increments on minutes and seconds overflow; wraps at 23
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else begin
        if (Mins == 6'd59 && Secs == 6'd59) begin
            if (Hours == 5'd23)
                Hours <= 5'd0;
            else
                Hours <= Hours + 5'd1;
        end else begin
            Hours <= Hours;
        end
    end
end

endmodule