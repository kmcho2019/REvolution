module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg [5:0]  Secs,
    output reg [5:0]  Mins,
    output reg [5:0]  Hours
);

// Seconds counter: 0 - 59
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

// Minutes counter: increments when seconds roll over (Secs==59)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else begin
        if ((Secs == 6'd59) && (Mins == 6'd59))
            Mins <= 6'd0;
        else if (Secs == 6'd59)
            Mins <= Mins + 6'd1;
        else
            Mins <= Mins; // hold value
    end
end

// Hours counter: increments when minutes and seconds both roll over (Mins==59 && Secs==59)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else begin
        if ((Mins == 6'd59) && (Secs == 6'd59) && (Hours == 6'd23))
            Hours <= 6'd0;
        else if ((Mins == 6'd59) && (Secs == 6'd59))
            Hours <= Hours + 6'd1;
        else
            Hours <= Hours; // hold value
    end
end

endmodule