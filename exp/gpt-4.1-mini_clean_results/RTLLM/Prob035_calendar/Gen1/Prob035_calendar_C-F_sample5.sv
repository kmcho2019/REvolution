module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 requires 5 bits
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

// Seconds counter: increments every clock cycle from 0 to 59
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else if (Secs == 6'd59) begin
        Secs <= 6'd0;
    end else begin
        Secs <= Secs + 6'd1;
    end
end

// Minutes counter: increments when seconds wrap from 59 to 0, wraps at 59
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (Mins == 6'd59 && Secs == 6'd59) begin
        Mins <= 6'd0;
    end else if (Secs == 6'd59) begin
        Mins <= Mins + 6'd1;
    end else begin
        Mins <= Mins;
    end
end

// Hours counter: increments when minutes and seconds wrap from 59 to 0, wraps at 23
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else if (Hours == 5'd23 && Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= 5'd0;
    end else if (Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= Hours + 5'd1;
    end else begin
        Hours <= Hours;
    end
end

endmodule