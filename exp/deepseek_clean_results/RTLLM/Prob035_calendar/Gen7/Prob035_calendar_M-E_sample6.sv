module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Unified 17-bit counter (0-86399 for 24 hours in seconds)
reg [16:0] total_seconds;

// Preemptive rollover detection (1 cycle early)
wire will_rollover = (total_seconds == 17'd86399);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        total_seconds <= 17'd0;
    end else begin
        total_seconds <= will_rollover ? 17'd0 : total_seconds + 17'd1;
    end
end

// Time decomposition (combinational)
always @(*) begin
    // Seconds = total_seconds % 60 (bits [5:0] since 60<64)
    Secs = total_seconds[5:0];
    
    // Minutes = (total_seconds / 60) % 60
    // Division by 60 through bit selection and adjustment
    reg [10:0] minutes_raw = total_seconds / 17'd60;
    Mins = minutes_raw[5:0];
    
    // Hours = total_seconds / 3600
    // Division by 3600 through bit selection
    Hours = total_seconds / 17'd3600;
end

// Validation logic (ensure proper decomposition)
always @(posedge CLK) begin
    if (!RST) begin
        assert(Secs < 60) else $error("Seconds overflow");
        assert(Mins < 60) else $error("Minutes overflow");
        assert(Hours < 24) else $error("Hours overflow");
    end
end

endmodule