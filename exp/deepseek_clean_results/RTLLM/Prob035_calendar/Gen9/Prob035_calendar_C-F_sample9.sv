module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,  // MSB always 0 (0-23)
    output reg [5:0] Mins,   // 0-59
    output reg [5:0] Secs    // 0-59
);

wire sec_rollover = (Secs == 6'd59);
wire min_rollover = (Mins == 6'd59) & sec_rollover;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Seconds counter
        if (sec_rollover) begin
            Secs <= 6'd0;
            
            // Minutes counter
            if (min_rollover) begin
                Mins <= 6'd0;
                
                // Hours counter
                if (Hours[4:0] == 5'd23)
                    Hours <= 6'd0;
                else
                    Hours <= {1'b0, Hours[4:0] + 5'd1};
            end else begin
                Mins <= Mins + 6'd1;
            end
        end else begin
            Secs <= Secs + 6'd1;
        end
    end
end

endmodule