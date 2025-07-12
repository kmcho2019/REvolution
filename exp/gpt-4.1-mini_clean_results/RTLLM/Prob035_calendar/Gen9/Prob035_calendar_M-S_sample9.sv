module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Secs   // 0-59
);

// Seconds counter: counts 0 to 59 and wraps
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else if (Secs == 6'd59) begin
        Secs <= 6'd0;
    end else begin
        Secs <= Secs + 6'd1;
    end
end

// Minutes and Hours counter combined: increments minutes when seconds wrap;
// increments hours when minutes and seconds both wrap.
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins  <= 6'd0;
        Hours <= 5'd0;
    end else if (Secs == 6'd59) begin
        if (Mins == 6'd59) begin
            Mins <= 6'd0;
            if (Hours == 5'd23)
                Hours <= 5'd0;
            else
                Hours <= Hours + 5'd1;
        end else begin
            Mins <= Mins + 6'd1;
        end
    end
end

endmodule