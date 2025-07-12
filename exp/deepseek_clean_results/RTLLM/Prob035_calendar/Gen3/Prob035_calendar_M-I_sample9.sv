module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

reg sec_rollover;
reg min_rollover;

// Seconds counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        sec_rollover <= 1'b0;
    end else begin
        sec_rollover <= (Secs == 6'd58); // Early flag generation
        Secs <= (Secs == 6'd59) ? 6'd0 : (Secs + 6'd1);
    end
end

// Minutes counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
        min_rollover <= 1'b0;
    end else if (sec_rollover) begin
        min_rollover <= (Mins == 6'd58);
        Mins <= (Mins == 6'd59) ? 6'd0 : (Mins + 6'd1);
    end
end

// Hours counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if (sec_rollover && min_rollover) begin
        Hours <= (Hours == 6'd23) ? 6'd0 : (Hours + 6'd1);
    end
end

endmodule