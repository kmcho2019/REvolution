module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,  // Standardized to 6 bits
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Parameterized constants
parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 6'd23;  // Now 6 bits

// One-hot encoding for max values
wire sec_max = (Secs == SEC_MAX);
wire min_max = (Mins == MIN_MAX);
wire hour_max = (Hours == HOUR_MAX);

// Pipeline registers for rollover signals
reg sec_roll_r, min_roll_r;

// Clock gating signals
wire sec_update_en = ~sec_max || (sec_max && ~min_max);
wire min_update_en = sec_roll_r && ~min_roll_r;
wire hour_update_en = min_roll_r && ~hour_max;

// Next state logic with pipelining
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
        sec_roll_r <= 1'b0;
        min_roll_r <= 1'b0;
    end else begin
        // Pipeline rollover signals
        sec_roll_r <= sec_max;
        min_roll_r <= sec_roll_r && min_max;
        
        // Update counters with clock gating
        if (sec_update_en) Secs <= sec_max ? 6'd0 : (Secs + 6'd1);
        if (min_update_en) Mins <= min_max ? 6'd0 : (Mins + 6'd1);
        if (hour_update_en) Hours <= hour_max ? 6'd0 : (Hours + 6'd1);
    end
end

endmodule