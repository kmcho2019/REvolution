module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours, // 0-23 stored in 6 bits for bus consistency
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Secs   // 0-59
);

always @(posedge CLK) begin
    if (RST) begin
        Hours <= 6'd0;
        Mins  <= 6'd0;
        Secs  <= 6'd0;
    end else begin
        // Calculate next seconds
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
            // Seconds wrapped, increment minutes
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
                // Minutes wrapped, increment hours
                if (Hours == 6'd23) begin
                    Hours <= 6'd0;
                end else begin
                    Hours <= Hours + 6'd1;
                end
            end else begin
                Mins <= Mins + 6'd1;
            end
        end else begin
            // Seconds increment normally
            Secs <= Secs + 6'd1;
            // Keep minutes and hours unchanged
            Mins <= Mins;
            Hours <= Hours;
        end
    end
end

endmodule