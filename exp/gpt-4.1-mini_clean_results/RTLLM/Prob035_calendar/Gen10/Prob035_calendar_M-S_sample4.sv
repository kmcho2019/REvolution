module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours,
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

// Seconds counter: increments every clock, rolls over at 59
always @(posedge CLK or posedge RST) begin
    if (RST)
        Secs <= 6'd0;
    else if (Secs == 6'd59)
        Secs <= 6'd0;
    else
        Secs <= Secs + 6'd1;
end

// Minutes counter: increments when seconds rolls over from 59 to 0
always @(posedge CLK or posedge RST) begin
    if (RST)
        Mins <= 6'd0;
    else if (Secs == 6'd59) begin
        if (Mins == 6'd59)
            Mins <= 6'd0;
        else
            Mins <= Mins + 6'd1;
    end
    else
        Mins <= Mins;
end

// Hours counter: increments when both minutes and seconds roll over from 59 to 0
always @(posedge CLK or posedge RST) begin
    if (RST)
        Hours <= 6'd0;
    else if ((Mins == 6'd59) && (Secs == 6'd59)) begin
        if (Hours == 6'd23)
            Hours <= 6'd0;
        else
            Hours <= Hours + 6'd1;
    end
    else
        Hours <= Hours;
end

endmodule