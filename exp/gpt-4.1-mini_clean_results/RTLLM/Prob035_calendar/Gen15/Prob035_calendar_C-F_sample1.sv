module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours,  // 0-23
    output reg  [5:0] Mins,   // 0-59
    output reg  [5:0] Secs    // 0-59
);

// Seconds counter: increments every clock, rolls over at 59
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

// Hours counter: increments when minutes and seconds roll over (Mins == 59 && Secs == 59)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else if ((Mins == 6'd59) && (Secs == 6'd59)) begin
        if (Hours == 5'd23) begin
            Hours <= 5'd0;
        end else begin
            Hours <= Hours + 5'd1;
        end
    end
end

endmodule