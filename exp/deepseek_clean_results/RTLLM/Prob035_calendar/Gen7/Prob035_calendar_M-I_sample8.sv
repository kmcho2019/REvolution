module calendar(
    input CLK,
    input RST,
    output wire [4:0] Hours,
    output wire [5:0] Mins,
    output wire [5:0] Secs
);

localparam MAX_SEC = 6'd59;
localparam MAX_MIN = 6'd59;
localparam MAX_HOUR = 5'd23;

// Gray code registers
reg [5:0] secs_gray, mins_gray;
reg [4:0] hours_gray;

// Binary conversion wires
wire [5:0] secs_bin, mins_bin;
wire [4:0] hours_bin;

// Enable signals
wire sec_inc, min_inc, hour_inc;

// Binary to Gray conversion
function [5:0] bin2gray6;
    input [5:0] bin;
    begin
        bin2gray6 = {bin[5], bin[5:1] ^ bin[4:0]};
    end
endfunction

function [4:0] bin2gray5;
    input [4:0] bin;
    begin
        bin2gray5 = {bin[4], bin[4:1] ^ bin[3:0]};
    end
endfunction

// Gray to Binary conversion
function [5:0] gray2bin6;
    input [5:0] gray;
    reg [5:0] bin;
    begin
        bin[5] = gray[5];
        for (integer i = 4; i >= 0; i = i - 1)
            bin[i] = bin[i+1] ^ gray[i];
        gray2bin6 = bin;
    end
endfunction

function [4:0] gray2bin5;
    input [4:0] gray;
    reg [4:0] bin;
    begin
        bin[4] = gray[4];
        for (integer i = 3; i >= 0; i = i - 1)
            bin[i] = bin[i+1] ^ gray[i];
        gray2bin5 = bin;
    end
endfunction

// Convert outputs to binary
assign Secs = gray2bin6(secs_gray);
assign Mins = gray2bin6(mins_gray);
assign Hours = gray2bin5(hours_gray);

// Rollover conditions
assign sec_inc = (gray2bin6(secs_gray) != MAX_SEC);
assign min_inc = (gray2bin6(mins_gray) != MAX_MIN) && (gray2bin6(secs_gray) == MAX_SEC);
assign hour_inc = (gray2bin5(hours_gray) != MAX_HOUR) && (gray2bin6(mins_gray) == MAX_MIN) && (gray2bin6(secs_gray) == MAX_SEC);

// First stage pipeline (seconds and minutes)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        secs_gray <= bin2gray6(6'd0);
        mins_gray <= bin2gray6(6'd0);
    end else begin
        // Seconds counter with Gray code
        if (sec_inc) begin
            secs_gray <= bin2gray6(gray2bin6(secs_gray) + 1);
        end else begin
            secs_gray <= bin2gray6(6'd0);
        end
        
        // Minutes counter with Gray code
        if (min_inc) begin
            mins_gray <= bin2gray6(gray2bin6(mins_gray) + 1);
        end else if (!sec_inc) begin
            mins_gray <= bin2gray6(6'd0);
        end
    end
end

// Second stage pipeline (hours)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        hours_gray <= bin2gray5(5'd0);
    end else if (hour_inc) begin
        hours_gray <= bin2gray5(gray2bin5(hours_gray) + 1);
    end else if (!min_inc && !sec_inc) begin
        hours_gray <= bin2gray5(5'd0);
    end
end

endmodule