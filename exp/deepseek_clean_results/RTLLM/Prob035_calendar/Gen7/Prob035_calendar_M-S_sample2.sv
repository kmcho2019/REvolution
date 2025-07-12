module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 0-23 (5 bits)
    output reg [5:0] Mins,   // 0-59 (6 bits)
    output reg [5:0] Secs    // 0-59 (6 bits)
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        // Seconds counter
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
            // Minutes counter
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
                // Hours counter
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