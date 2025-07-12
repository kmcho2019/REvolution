module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours,  // 0-23 needs 5 bits
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

// Seconds counter: increments every clock, rolls over at 59 -> 0
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else if (Secs == 6'd59) begin
        Secs <= 6'd0;
    end else begin
        Secs <= Secs + 6'd1;
    end
end

// Minutes counter: increments when seconds roll over from 59 to 0
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (Secs == 6'd59) begin
        if (Mins == 6'd59) begin
            Mins <= 6'd0;
        end else begin
            Mins <= Mins + 6'd1;
        end
    end
end

// Hours counter: increments when minutes roll over from 59 to 0 and seconds are 59 (just rolled)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else if (Mins == 6'd59 && Secs == 6'd59) begin
        if (Hours == 5'd23) begin
            Hours <= 5'd0;
        end else begin
            Hours <= Hours + 5'd1;
        end
    end
end

endmodule