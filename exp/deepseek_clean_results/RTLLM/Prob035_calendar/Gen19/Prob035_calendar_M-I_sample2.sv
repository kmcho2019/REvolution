module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

reg [4:0] hours_int;  // Internal 5-bit hours register

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        hours_int <= 5'd0;
    end else begin
        // Seconds counter
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
            // Minutes counter
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
                // Hours counter
                if (hours_int == 5'd23) begin
                    hours_int <= 5'd0;
                end else begin
                    hours_int <= hours_int + 5'd1;
                end
            end else begin
                Mins <= Mins + 6'd1;
            end
        end else begin
            Secs <= Secs + 6'd1;
        end
    end
end

// Zero-extend hours to 6-bit output
always @(*) begin
    Hours = {1'b0, hours_int};
end

endmodule