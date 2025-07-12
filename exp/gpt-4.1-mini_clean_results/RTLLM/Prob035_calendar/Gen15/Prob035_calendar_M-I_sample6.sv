module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours, // 0-23, 6-bit per specification
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Secs   // 0-59
);

// Seconds counter: increments every clock cycle, wraps at 59 to 0
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

// Minutes and Hours counter combined to optimize logic and update only when needed
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else if (Secs == 6'd59) begin // when seconds wrap next cycle, increment mins/hours as needed
        if (Mins == 6'd59) begin
            Mins <= 6'd0;
            if (Hours == 6'd23)
                Hours <= 6'd0;
            else
                Hours <= Hours + 6'd1;
        end else begin
            Mins <= Mins + 6'd1;
            Hours <= Hours; // hold current hours
        end
    end else begin
        Mins <= Mins;   // hold current minutes
        Hours <= Hours; // hold current hours
    end
end

endmodule