module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Gray code conversion functions
function [5:0] bin2gray;
    input [5:0] bin;
    begin
        bin2gray = bin ^ (bin >> 1);
    end
endfunction

function [5:0] gray2bin;
    input [5:0] gray;
    reg [5:0] bin;
    begin
        bin[5] = gray[5];
        bin[4] = gray[4] ^ bin[5];
        bin[3] = gray[3] ^ bin[4];
        bin[2] = gray[2] ^ bin[3];
        bin[1] = gray[1] ^ bin[2];
        bin[0] = gray[0] ^ bin[1];
        gray2bin = bin;
    end
endfunction

// Internal Gray-coded counters
reg [5:0] secs_gray, mins_gray, hours_gray;
wire [5:0] secs_bin = gray2bin(secs_gray);
wire [5:0] mins_bin = gray2bin(mins_gray);
wire [5:0] hours_bin = gray2bin(hours_gray);

// Gated comparison signals (only active near rollover)
wire sec_compare_en = (secs_bin >= 6'd58);
wire min_compare_en = (mins_bin >= 6'd58) & sec_compare_en;
wire hour_compare_en = (hours_bin >= 6'd22) & min_compare_en;

wire sec_rollover = sec_compare_en & (secs_bin == 6'd59);
wire min_rollover = min_compare_en & (mins_bin == 6'd59) & sec_rollover;
wire hour_rollover = hour_compare_en & (hours_bin == 6'd23) & min_rollover;

// Pipeline registers for rollover signals
reg sec_rollover_q, min_rollover_q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        secs_gray <= bin2gray(6'd0);
        mins_gray <= bin2gray(6'd0);
        hours_gray <= bin2gray(6'd0);
        sec_rollover_q <= 1'b0;
        min_rollover_q <= 1'b0;
    end else begin
        // Pipeline stage 1: Update seconds and capture rollovers
        if (sec_rollover) begin
            secs_gray <= bin2gray(6'd0);
        end else begin
            secs_gray <= bin2gray(gray2bin(secs_gray) + 6'd1);
        end
        sec_rollover_q <= sec_rollover;
        
        // Pipeline stage 2: Update minutes
        if (sec_rollover_q) begin
            if (min_rollover) begin
                mins_gray <= bin2gray(6'd0);
            end else begin
                mins_gray <= bin2gray(gray2bin(mins_gray) + 6'd1);
            end
            min_rollover_q <= min_rollover;
        end
        
        // Pipeline stage 3: Update hours
        if (min_rollover_q & sec_rollover_q) begin
            if (hour_rollover) begin
                hours_gray <= bin2gray(6'd0);
            end else begin
                hours_gray <= bin2gray(gray2bin(hours_gray) + 6'd1);
            end
        end
    end
end

// Convert Gray code to binary for outputs
assign Hours = gray2bin(hours_gray);
assign Mins = gray2bin(mins_gray);
assign Secs = gray2bin(secs_gray);

endmodule