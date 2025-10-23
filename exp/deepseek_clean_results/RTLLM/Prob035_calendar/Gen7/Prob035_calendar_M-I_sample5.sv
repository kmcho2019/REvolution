module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 5 bits for 0-23
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Gray code encoding for seconds (reduces switching power)
reg [5:0] secs_gray;
wire [5:0] secs_bin = {secs_gray[5],
                      secs_gray[5] ^ secs_gray[4],
                      secs_gray[4] ^ secs_gray[3],
                      secs_gray[3] ^ secs_gray[2],
                      secs_gray[2] ^ secs_gray[1],
                      secs_gray[1] ^ secs_gray[0]};

// Registered rollover flags (pipelined for timing)
reg sec_rollover_q, min_rollover_q;
wire sec_rollover = (secs_bin == 6'd59);
wire min_rollover = (Mins == 6'd59) & sec_rollover;
wire hour_rollover = (Hours == 5'd23) & min_rollover;

// Enable signals for power optimization
wire mins_en = sec_rollover_q;
wire hours_en = min_rollover_q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
        Mins <= 6'd0;
        secs_gray <= 6'd0;
        sec_rollover_q <= 1'b0;
        min_rollover_q <= 1'b0;
    end else begin
        // Pipeline rollover flags
        sec_rollover_q <= sec_rollover;
        min_rollover_q <= min_rollover;
        
        // Gray code seconds counter
        if (sec_rollover) begin
            secs_gray <= 6'd0;
        end else begin
            secs_gray <= secs_bin + 1'b1;
            secs_gray <= secs_gray ^ ((secs_bin + 1'b1) >> 1); // Binary to Gray
        end
        
        // Minutes update (enabled only when needed)
        if (mins_en) begin
            Mins <= min_rollover_q ? 6'd0 : (Mins + 6'd1);
        end
        
        // Hours update (enabled only when needed)
        if (hours_en) begin
            Hours <= hour_rollover ? 5'd0 : (Hours + 5'd1);
        end
    end
end

// Convert Gray code back to binary for output
assign Secs = secs_bin;

endmodule