module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SEC_MIN = 6'd59;
localparam MAX_HOUR = 6'd23;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Seconds counter with clock gating
        if (Secs < MAX_SEC_MIN)
            Secs <= Secs + 1;
        else
            Secs <= 0;

        // Minutes counter with clock gating
        if (Secs == MAX_SEC_MIN) begin
            if (Mins < MAX_SEC_MIN)
                Mins <= Mins + 1;
            else
                Mins <= 0;
        end

        // Hours counter with clock gating
        if ((Secs == MAX_SEC_MIN) && (Mins == MAX_SEC_MIN)) begin
            if (Hours < MAX_HOUR)
                Hours <= Hours + 1;
            else
                Hours <= 0;
        end
    end
end

endmodule