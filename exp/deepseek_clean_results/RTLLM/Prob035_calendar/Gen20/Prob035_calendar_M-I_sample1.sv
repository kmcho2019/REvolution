module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SEC_MIN = 6'd59;
localparam MAX_HOUR = 6'd23;

// Pre-compute rollover conditions
reg sec_rollover;
reg min_rollover;
reg hour_rollover;

always @(*) begin
    sec_rollover = (Secs == MAX_SEC_MIN);
    min_rollover = (Mins == MAX_SEC_MIN) & sec_rollover;
    hour_rollover = (Hours == MAX_HOUR) & min_rollover;
end

always @(posedge CLK) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Seconds counter with clock gating
        if (!sec_rollover)
            Secs <= Secs + 1;
        else
            Secs <= 0;

        // Minutes counter with clock gating
        if (sec_rollover) begin
            if (!min_rollover)
                Mins <= Mins + 1;
            else
                Mins <= 0;
        end

        // Hours counter with clock gating
        if (min_rollover) begin
            if (!hour_rollover)
                Hours <= Hours + 1;
            else
                Hours <= 0;
        end
    end
end

endmodule