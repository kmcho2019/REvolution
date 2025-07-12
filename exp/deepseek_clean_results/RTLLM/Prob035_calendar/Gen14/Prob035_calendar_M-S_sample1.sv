module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,  // 6 bits for 0-23 (5 bits would suffice but keeping consistent)
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Parameterized constants
parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 6'd23;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        // Seconds update
        if (Secs == SEC_MAX) begin
            Secs <= 6'd0;
            // Minutes update when seconds roll over
            if (Mins == MIN_MAX) begin
                Mins <= 6'd0;
                // Hours update when both seconds and minutes roll over
                if (Hours == HOUR_MAX) begin
                    Hours <= 6'd0;
                end else begin
                    Hours <= Hours + 6'd1;
                end
            end else begin
                Mins <= Mins + 6'd1;
            end
        end else begin
            Secs <= Secs + 6'd1;
        end
    end
end

endmodule