module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours,
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

// Seconds counter: counts 0 to 59, increments every clock cycle
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

// Minutes counter: increments by 1 when seconds wrap from 59 to 0; counts 0 to 59
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (Secs == 6'd59) begin
        if (Mins == 6'd59)
            Mins <= 6'd0;
        else
            Mins <= Mins + 6'd1;
    end
end

// Hours counter: increments by 1 when minutes and seconds wrap from 59 to 0; counts 0 to 23
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if ((Mins == 6'd59) && (Secs == 6'd59)) begin
        if (Hours == 6'd23)
            Hours <= 6'd0;
        else
            Hours <= Hours + 6'd1;
    end
end

endmodule