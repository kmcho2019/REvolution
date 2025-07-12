module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Parameterized constants
parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 6'd23;

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

// Internal signals
reg sec_roll = 0;
reg min_roll = 0;
reg [5:0] sec_gray;
reg [5:0] min_gray;
reg [5:0] hour_gray;

// Seconds counter (gray coded)
always @(posedge CLK) begin
    if (RST) begin
        sec_gray <= bin2gray(6'd0);
        sec_roll <= 0;
    end else begin
        // Convert to binary, increment, check rollover, then back to gray
        if (gray2bin(sec_gray) == SEC_MAX) begin
            sec_gray <= bin2gray(6'd0);
            sec_roll <= 1;
        end else begin
            sec_gray <= bin2gray(gray2bin(sec_gray) + 1);
            sec_roll <= 0;
        end
    end
end

// Minutes counter (gray coded)
always @(posedge CLK) begin
    if (RST) begin
        min_gray <= bin2gray(6'd0);
        min_roll <= 0;
    end else if (sec_roll) begin
        if (gray2bin(min_gray) == MIN_MAX) begin
            min_gray <= bin2gray(6'd0);
            min_roll <= 1;
        end else begin
            min_gray <= bin2gray(gray2bin(min_gray) + 1);
            min_roll <= 0;
        end
    end else begin
        min_roll <= 0;
    end
end

// Hours counter (gray coded)
always @(posedge CLK) begin
    if (RST) begin
        hour_gray <= bin2gray(6'd0);
    end else if (sec_roll && min_roll) begin
        if (gray2bin(hour_gray) == HOUR_MAX) begin
            hour_gray <= bin2gray(6'd0);
        end else begin
            hour_gray <= bin2gray(gray2bin(hour_gray) + 1);
        end
    end
end

// Convert gray codes to binary outputs
always @(*) begin
    Secs = gray2bin(sec_gray);
    Mins = gray2bin(min_gray);
    Hours = gray2bin(hour_gray);
end

endmodule