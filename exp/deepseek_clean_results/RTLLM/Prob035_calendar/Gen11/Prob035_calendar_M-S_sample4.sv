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
        // Handle seconds
        if (Secs == 59) begin
            Secs <= 0;
            // Handle minutes when seconds roll over
            if (Mins == 59) begin
                Mins <= 0;
                // Handle hours when both seconds and minutes roll over
                if (Hours == 23)
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