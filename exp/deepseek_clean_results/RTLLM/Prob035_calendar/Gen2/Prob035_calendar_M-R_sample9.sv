module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

wire min_en = (Secs == 6'd59);
wire hour_en = (Mins == 6'd59) & min_en;

always @(posedge CLK) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Update seconds
        if (Secs == 6'd59)
            Secs <= 6'd0;
        else
            Secs <= Secs + 6'd1;
        
        // Update minutes when enabled
        if (min_en) begin
            if (Mins == 6'd59)
                Mins <= 6'd0;
            else
                Mins <= Mins + 6'd1;
        end
        
        // Update hours when enabled
        if (hour_en) begin
            if (Hours == 6'd23)
                Hours <= 6'd0;
            else
                Hours <= Hours + 6'd1;
        end
    end
end

endmodule