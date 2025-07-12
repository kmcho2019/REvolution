module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        // Always increment seconds
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
            // When seconds roll over, increment minutes
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
                // When minutes roll over, increment hours
                if (Hours == 5'd23)
                    Hours <= 5'd0;
                else
                    Hours <= Hours + 5'd1;
            end else begin
                Mins <= Mins + 6'd1;
            end
        end else begin
            Secs <= Secs + 6'd1;
        end
    end
end

endmodule