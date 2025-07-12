module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        // Handle seconds rollover
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
            // Handle minutes rollover when seconds reach 59
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
                // Handle hours rollover when both minutes and seconds reach 59
                if (Hours == 6'd23)
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