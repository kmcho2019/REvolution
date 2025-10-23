module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 0;
        Mins <= 0;
        Hours <= 0;
    end else begin
        // Seconds counter
        if (Secs == 59) begin
            Secs <= 0;
            // Minutes counter
            if (Mins == 59) begin
                Mins <= 0;
                // Hours counter
                if (Hours == 23)
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