module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,  // 6 bits for 0-23 (consistent width)
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 6'd23;  // Now 6-bit for consistency

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        // Seconds increment with rollover
        if (Secs == SEC_MAX) begin
            Secs <= 6'd0;
            // Minutes increment when seconds roll over
            if (Mins == MIN_MAX) begin
                Mins <= 6'd0;
                // Hours increment when both roll over
                if (Hours == HOUR_MAX)
                    Hours <= 6'd0;
                else
                    Hours <= Hours + 6'd1;
            end else begin
                Mins <= Mins + 6'd1;
            end
        end else begin
            Secs <= Secs + 6'd1;
        end
    end
end

endmodule