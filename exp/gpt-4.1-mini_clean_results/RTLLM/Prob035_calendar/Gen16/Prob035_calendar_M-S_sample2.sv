module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours, // 0-23 (using 6 bits as requested)
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Secs   // 0-59
);

// Seconds counter
always @(posedge CLK or posedge RST) begin
    if (RST)
        Secs <= 6'd0;
    else if (Secs == 6'd59)
        Secs <= 6'd0;
    else
        Secs <= Secs + 6'd1;
end

// Minutes counter
always @(posedge CLK or posedge RST) begin
    if (RST)
        Mins <= 6'd0;
    else if (Secs == 6'd59) begin
        if (Mins == 6'd59)
            Mins <= 6'd0;
        else
            Mins <= Mins + 6'd1;
    end
end

// Hours counter
always @(posedge CLK or posedge RST) begin
    if (RST)
        Hours <= 6'd0;
    else if (Mins == 6'd59 && Secs == 6'd59) begin
        if (Hours == 6'd23)
            Hours <= 6'd0;
        else
            Hours <= Hours + 6'd1;
    end
end

endmodule