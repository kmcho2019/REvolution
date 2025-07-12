module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SEC = 6'd59;
localparam MAX_MIN = 6'd59;
localparam MAX_HOUR = 6'd23;

// Combinational rollover logic
wire sec_rollover = (Secs == MAX_SEC);
wire min_rollover = (Mins == MAX_MIN) & sec_rollover;
wire hour_rollover = (Hours == MAX_HOUR) & min_rollover;

// Registered enable signals
reg sec_en, min_en, hour_en;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        sec_en <= 1'b1;
        min_en <= 1'b0;
        hour_en <= 1'b0;
    end else begin
        sec_en <= 1'b1;  // Always enabled
        min_en <= sec_rollover;
        hour_en <= min_rollover;
    end
end

// Sequential counter updates
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Seconds counter (always updates)
        if (sec_en) begin
            Secs <= sec_rollover ? 6'd0 : Secs + 6'd1;
        end
        
        // Minutes counter (only when seconds roll over)
        if (min_en) begin
            Mins <= min_rollover ? 6'd0 : Mins + 6'd1;
        end
        
        // Hours counter (only when minutes roll over)
        if (hour_en) begin
            Hours <= hour_rollover ? 6'd0 : Hours + 6'd1;
        end
    end
end

endmodule