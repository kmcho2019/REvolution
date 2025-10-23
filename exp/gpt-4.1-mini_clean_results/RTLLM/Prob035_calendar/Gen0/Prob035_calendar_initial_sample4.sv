module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg [5:0]  Hours,
    output reg [5:0]  Mins,
    output reg [5:0]  Secs
);

// Seconds counter: 0 to 59, increments every clock cycle
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

// Minutes counter: increments when seconds wrap from 59 to 0
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else begin
        if (Mins == 6'd59 && Secs == 6'd59)
            Mins <= 6'd0;
        else if (Secs == 6'd59)
            Mins <= Mins + 6'd1;
        else
            Mins <= Mins;
    end
end

// Hours counter: increments when minutes and seconds wrap from 59 to 0
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else begin
        if (Hours == 6'd23 && Mins == 6'd59 && Secs == 6'd59)
            Hours <= 6'd0;
        else if (Mins == 6'd59 && Secs == 6'd59)
            Hours <= Hours + 6'd1;
        else
            Hours <= Hours;
    end
end

endmodule