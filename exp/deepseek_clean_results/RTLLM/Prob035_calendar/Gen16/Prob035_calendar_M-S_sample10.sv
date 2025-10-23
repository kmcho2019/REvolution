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
        // Seconds counter
        if (Secs == MAX_SEC_MIN) begin
            Secs <= 0;
            // Minutes counter
            if (Mins == MAX_SEC_MIN) begin
                Mins <= 0;
                // Hours counter
                if (Hours == MAX_HOUR)
                    Hours <= 0;
                else
                    Hours <= Hours + 1;
            end else begin
                Mins <= Mins + 1;
            end
        end else begin
            Secs <= Secs + 1;
        end
    end
end

endmodule