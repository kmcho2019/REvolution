module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 requires 5 bits
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

    wire secs_rollover = (Secs == 6'd59);
    wire mins_rollover = (Mins == 6'd59);

    always @(posedge CLK) begin
        if (RST) begin
            Secs  <= 6'd0;
            Mins  <= 6'd0;
            Hours <= 5'd0;
        end else begin
            // Seconds increment or rollover
            if (secs_rollover) begin
                Secs <= 6'd0;

                // Minutes increment or rollover when seconds rollover
                if (mins_rollover) begin
                    Mins <= 6'd0;

                    // Hours increment or rollover when minutes and seconds rollover
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