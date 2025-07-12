module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// 32-bit tick counter (enough for >136 years of counting)
reg [31:0] tick_counter;

// Division constants
localparam SECS_PER_MIN = 60;
localparam MINS_PER_HOUR = 60;
localparam HOURS_PER_DAY = 24;
localparam TICKS_PER_SEC = 1; // Can be increased for sub-second precision

// Efficient division by 60 (SECS_PER_MIN/MINS_PER_HOUR)
function [31:0] div60;
    input [31:0] val;
    reg [31:0] q;
    begin
        // Division by 60 = 64 - 4, using shifts and adds
        q = (val >> 6);           // Divide by 64
        q = q + (val >> 8);       // Add 1/256th
        q = q + (val >> 10);      // Add 1/1024th
        q = q + (val >> 12);      // Add 1/4096th
        // Compensate for approximation error
        if ((val - q*60) >= 60) q = q + 1;
        div60 = q;
    end
endfunction

// Efficient modulo 60
function [5:0] mod60;
    input [31:0] val;
    reg [31:0] q;
    begin
        q = div60(val);
        mod60 = val - q*60;
    end
endfunction

// Time conversion pipeline registers
reg [31:0] total_secs;
reg [31:0] total_mins;
reg [31:0] total_hours;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        tick_counter <= 0;
        total_secs <= 0;
        total_mins <= 0;
        total_hours <= 0;
    end else begin
        // Main counter increment
        tick_counter <= tick_counter + TICKS_PER_SEC;
        
        // Pipeline stage 1: Calculate total seconds
        total_secs <= tick_counter;
        
        // Pipeline stage 2: Calculate minutes and seconds
        total_mins <= div60(total_secs);
        
        // Pipeline stage 3: Calculate hours and minutes
        total_hours <= div60(total_mins);
    end
end

// Output generation (combinational)
always @(*) begin
    Secs = mod60(total_secs);
    Mins = mod60(total_mins);
    Hours = total_hours % HOURS_PER_DAY;
end

endmodule