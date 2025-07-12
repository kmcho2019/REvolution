module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,  // Changed to 6-bit for uniformity
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Gray code conversion functions
function [5:0] bin2gray(input [5:0] bin);
    bin2gray = bin ^ (bin >> 1);
endfunction

function [5:0] gray2bin(input [5:0] gray);
    gray2bin = {gray[5], 
               gray[4] ^ gray2bin[5],
               gray[3] ^ gray2bin[4],
               gray[2] ^ gray2bin[3],
               gray[1] ^ gray2bin[2],
               gray[0] ^ gray2bin[1]};
endfunction

// Internal Gray-coded counters
reg [5:0] secs_gray, mins_gray, hours_gray;
wire [5:0] next_secs_gray, next_mins_gray, next_hours_gray;

// Rollover flags (parallel computation)
wire sec_rollover = (gray2bin(secs_gray) == 6'd59);
wire min_rollover = (gray2bin(mins_gray) == 6'd59) & sec_rollover;
wire hour_rollover = (gray2bin(hours_gray) == 6'd23) & min_rollover;

// Gated comparison enables (only active near rollover)
wire cmp_enable = (gray2bin(secs_gray) >= 6'd58);

// Next counter values
assign next_secs_gray = RST ? 6'd0 : 
                       sec_rollover ? 6'd0 : 
                       bin2gray(gray2bin(secs_gray) + 1);

assign next_mins_gray = RST ? 6'd0 : 
                       (sec_rollover & cmp_enable) ? 
                       (min_rollover ? 6'd0 : 
                       bin2gray(gray2bin(mins_gray) + 1)) : 
                       mins_gray;

assign next_hours_gray = RST ? 6'd0 : 
                        (min_rollover & cmp_enable) ? 
                        (hour_rollover ? 6'd0 : 
                        bin2gray(gray2bin(hours_gray) + 1)) : 
                        hours_gray;

always @(posedge CLK) begin
    // Update Gray-coded counters
    secs_gray <= next_secs_gray;
    if (cmp_enable) begin
        mins_gray <= next_mins_gray;
        if (min_rollover)
            hours_gray <= next_hours_gray;
    end
    
    // Convert to binary outputs (only when needed)
    if (RST || sec_rollover || min_rollover || hour_rollover) begin
        Secs <= gray2bin(secs_gray);
        Mins <= gray2bin(mins_gray);
        Hours <= gray2bin(hours_gray);
    end
end

endmodule