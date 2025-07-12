module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Secs,  // 0-59
    output reg  [5:0] Mins,  // 0-59
    output reg  [4:0] Hours  // 0-23
);

// Seconds counter: increments every clock cycle, wraps at 59
always @(posedge CLK or posedge RST) begin
    if (RST)
        Secs <= 6'd0;
    else if (Secs == 6'd59)
        Secs <= 6'd0;
    else
        Secs <= Secs + 6'd1;
end

// Minutes counter: increments when seconds wrap from 59 to 0, wraps at 59
always @(posedge CLK or posedge RST) begin
    if (RST)
        Mins <= 6'd0;
    else if (Secs == 6'd59) begin
        if (Mins == 6'd59)
            Mins <= 6'd0;
        else
            Mins <= Mins + 6'd1;
    end else
        Mins <= Mins; // hold value
end

// Hours counter: increments when minutes and seconds wrap, wraps at 23
always @(posedge CLK or posedge RST) begin
    if (RST)
        Hours <= 5'd0;
    else if ((Mins == 6'd59) && (Secs == 6'd59)) begin
        if (Hours == 5'd23)
            Hours <= 5'd0;
        else
            Hours <= Hours + 5'd1;
    end else
        Hours <= Hours; // hold value
end

endmodule