module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,  // 0-23 as 6-bit for consistency
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SEC = 6'd59;
localparam MAX_MIN = 6'd59;
localparam MAX_HOUR = 6'd23;

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
reg [5:0] next_sec, next_min, next_hour;
reg sec_en, min_en, hour_en;
wire sec_max = (Secs == MAX_SEC);
wire min_max = (Mins == MAX_MIN);
wire hour_max = (Hours == MAX_HOUR);

// Combinational next-state logic
always @(*) begin
    // Default enables
    sec_en = 1'b1;
    min_en = sec_max;
    hour_en = sec_max & min_max;
    
    // Next state calculations
    next_sec = sec_max ? 6'd0 : (Secs + 6'd1);
    next_min = min_en ? (min_max ? 6'd0 : (Mins + 6'd1)) : Mins;
    next_hour = hour_en ? (hour_max ? 6'd0 : (gray2bin(bin2gray(Hours) + 6'd1))) : Hours;
end

// Sequential state update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        Secs <= next_sec;
        if (min_en) Mins <= next_min;
        if (hour_en) Hours <= next_hour;
    end
end

endmodule