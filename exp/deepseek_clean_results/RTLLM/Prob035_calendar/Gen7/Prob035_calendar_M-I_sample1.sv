module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 5 bits for 0-23
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Gray code for seconds counter (reduces switching)
reg [5:0] secs_gray;
wire [5:0] next_secs_gray = (Secs == 6'd59) ? 6'd0 : (secs_gray ^ ((secs_gray & -secs_gray) << 1));

// Registered rollover flags
reg sec_max, min_max, hour_max;
always @(posedge CLK) begin
    sec_max <= (Secs == 6'd59);
    min_max <= (Mins == 6'd59);
    hour_max <= (Hours == 5'd23);
end

// Next value computation
wire [5:0] next_secs = (sec_max) ? 6'd0 : (Secs + 6'd1);
wire [5:0] next_mins = (sec_max) ? ((min_max) ? 6'd0 : (Mins + 6'd1)) : Mins;
wire [4:0] next_hours = (sec_max & min_max) ? ((hour_max) ? 5'd0 : (Hours + 5'd1)) : Hours;

always @(posedge CLK) begin
    if (RST) begin
        // Synchronous reset
        Hours <= 5'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
        secs_gray <= 6'd0;
    end else begin
        // Update with parallel computed values
        Secs <= next_secs;
        secs_gray <= next_secs_gray;
        Mins <= next_mins;
        Hours <= next_hours;
    end
end

// Optional: Clock gating for power savings
// Would require additional enable logic based on rollover conditions

endmodule