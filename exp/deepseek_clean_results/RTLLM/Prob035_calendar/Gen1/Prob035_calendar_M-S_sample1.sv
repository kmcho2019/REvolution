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
        // Increment seconds with rollover
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
            // Increment minutes when seconds roll over
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
                // Increment hours when minutes roll over
                if (Hours == 6'd23) begin
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