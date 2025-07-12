module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Unified time counter (0 to 86399)
reg [16:0] total_seconds;

// Conversion constants
localparam SECONDS_PER_DAY = 17'd86400;
localparam SECONDS_PER_HOUR = 17'd3600;
localparam SECONDS_PER_MINUTE = 17'd60;

// Conversion pipeline registers
reg [16:0] remaining_after_hours;
reg [16:0] remaining_after_minutes;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        total_seconds <= 17'd0;
    end else begin
        // Increment or wrap around at end of day
        total_seconds <= (total_seconds == SECONDS_PER_DAY - 1) ? 
                         17'd0 : total_seconds + 17'd1;
    end
end

// Time conversion pipeline (combinational)
always @(*) begin
    // Stage 1: Calculate hours and remaining seconds
    Hours = total_seconds / SECONDS_PER_HOUR;
    remaining_after_hours = total_seconds % SECONDS_PER_HOUR;
    
    // Stage 2: Calculate minutes and remaining seconds
    Mins = remaining_after_hours / SECONDS_PER_MINUTE;
    remaining_after_minutes = remaining_after_hours % SECONDS_PER_MINUTE;
    
    // Stage 3: Calculate seconds
    Secs = remaining_after_minutes;
end

endmodule