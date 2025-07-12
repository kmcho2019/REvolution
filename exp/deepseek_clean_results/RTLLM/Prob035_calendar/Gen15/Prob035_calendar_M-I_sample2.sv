module calendar (
    input CLK,
    input RST,
    output [4:0] Hours,  // 0-23 (5 bits)
    output [5:0] Mins,
    output [5:0] Secs
);

localparam MAX_SEC = 6'd59;
localparam MAX_MIN = 6'd59;
localparam MAX_HOUR = 5'd23;

// Internal binary counters
reg [5:0] sec_bin, min_bin;
reg [4:0] hour_bin;

// Gray code outputs
assign Secs = {sec_bin[5], sec_bin[5:1] ^ sec_bin[4:0]};
assign Mins = {min_bin[5], min_bin[5:1] ^ min_bin[4:0]};
assign Hours = {hour_bin[4], hour_bin[4:1] ^ hour_bin[3:0]};

// Pre-computed next values
wire [5:0] next_sec = (sec_bin == MAX_SEC) ? 6'd0 : (sec_bin + 6'd1);
wire [5:0] next_min = (min_bin == MAX_MIN) ? 6'd0 : (min_bin + 6'd1);
wire [4:0] next_hour = (hour_bin == MAX_HOUR) ? 5'd0 : (hour_bin + 5'd1);

// Enable signals (clock gating)
wire sec_en = 1'b1;  // Always count seconds
wire min_en = (sec_bin == MAX_SEC);
wire hour_en = (sec_bin == MAX_SEC) && (min_bin == MAX_MIN);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        sec_bin <= 6'd0;
        min_bin <= 6'd0;
        hour_bin <= 5'd0;
    end else begin
        // Seconds counter (always enabled)
        sec_bin <= next_sec;
        
        // Minutes counter (enabled on sec rollover)
        if (min_en) begin
            min_bin <= next_min;
        end
        
        // Hours counter (enabled on min rollover)
        if (hour_en) begin
            hour_bin <= next_hour;
        end
    end
end

endmodule