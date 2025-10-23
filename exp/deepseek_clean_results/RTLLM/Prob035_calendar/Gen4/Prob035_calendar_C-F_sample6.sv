module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 5 bits for 0-23
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Rollover flags
wire sec_max = (Secs == 6'd59);
wire min_max = (Mins == 6'd59);
wire hour_max = (Hours == 5'd23);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset all counters
        Hours <= 5'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        // Update seconds
        if (sec_max) begin
            Secs <= 6'd0;
            
            // Update minutes when seconds roll over
            if (min_max) begin
                Mins <= 6'd0;
                
                // Update hours when minutes and seconds roll over
                if (hour_max) begin
                    Hours <= 5'd0;
                end else begin
                    Hours <= Hours + 5'd1;
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