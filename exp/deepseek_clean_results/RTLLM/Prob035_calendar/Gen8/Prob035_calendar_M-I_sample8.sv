module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SEC = 6'd59;
localparam MAX_MIN = 6'd59;
localparam MAX_HOUR = 5'd23;

reg sec_rollover_q, min_rollover_q;
wire sec_rollover = (Secs == MAX_SEC);
wire min_rollover = (Mins == MAX_MIN) & sec_rollover_q;
wire hour_rollover = (Hours[4:0] == MAX_HOUR) & min_rollover_q;

// Next state logic
wire [5:0] next_sec = sec_rollover ? 6'd0 : Secs + 6'd1;
wire [5:0] next_min = (sec_rollover_q) ? 
                     (min_rollover_q ? 6'd0 : Mins + 6'd1) : Mins;
wire [5:0] next_hour = (min_rollover_q) ? 
                      (hour_rollover ? 6'd0 : {1'b0, Hours[4:0] + 5'd1}) : Hours;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
        sec_rollover_q <= 1'b0;
        min_rollover_q <= 1'b0;
    end else begin
        // Register rollover signals
        sec_rollover_q <= sec_rollover;
        min_rollover_q <= min_rollover;
        
        // Update counters
        Secs <= next_sec;
        Mins <= next_min;
        Hours <= next_hour;
    end
end

endmodule