module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 5'd23;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 0;
        Mins <= 0;
        Hours <= 0;
    end else begin
        // Seconds counter
        if (Secs == SEC_MAX) begin
            Secs <= 0;
            // Minutes counter
            if (Mins == MIN_MAX) begin
                Mins <= 0;
                // Hours counter
                if (Hours == HOUR_MAX)
                    Hours <= 0;
                else
                    Hours <= Hours + 1;
            end else
                Mins <= Mins + 1;
        end else
            Secs <= Secs + 1;
    end
end

endmodule