module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg [5:0]  Hours,  // 6-bit output for hours (0-23 used)
    output reg [5:0]  Mins,   // 6-bit output for minutes (0-59)
    output reg [5:0]  Secs    // 6-bit output for seconds (0-59)
);

// Seconds counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else begin
        if (Secs == 6'd59)
            Secs <= 6'd0;
        else
            Secs <= Secs + 6'd1;
    end
end

// Minutes counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else begin
        // Increment minutes when seconds roll over
        if (Secs == 6'd59) begin
            if (Mins == 6'd59)
                Mins <= 6'd0;
            else
                Mins <= Mins + 6'd1;
        end else begin
            Mins <= Mins; // Hold value if no rollover
        end
    end
end

// Hours counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else begin
        // Increment hours when both minutes and seconds roll over
        if ((Mins == 6'd59) && (Secs == 6'd59)) begin
            if (Hours == 6'd23)
                Hours <= 6'd0;
            else
                Hours <= Hours + 6'd1;
        end else begin
            Hours <= Hours; // Hold value if no rollover
        end
    end
end

endmodule