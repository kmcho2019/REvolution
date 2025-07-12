module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 5 bits for 0-23
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

// Internal signals
reg [5:0] sec_gray, min_gray;
reg [4:0] hour_gray;
wire [5:0] next_sec = (Secs == 6'd59) ? 6'd0 : (Secs + 6'd1);
wire sec_enable = 1'b1;  // Always counting
wire min_enable = (Secs == 6'd59);
wire hour_enable = (Secs == 6'd59) && (Mins == 6'd59);

// Seconds counter (always counting)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        sec_gray <= 6'd0;
    end else begin
        Secs <= next_sec;
        sec_gray <= bin2gray(next_sec);
    end
end

// Minutes counter (only updates when seconds roll over)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
        min_gray <= 6'd0;
    end else if (min_enable) begin
        Mins <= (Mins == 6'd59) ? 6'd0 : (Mins + 6'd1);
        min_gray <= bin2gray((Mins == 6'd59) ? 6'd0 : (Mins + 6'd1));
    end
end

// Hours counter (only updates when minutes and seconds roll over)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
        hour_gray <= 5'd0;
    end else if (hour_enable) begin
        Hours <= (Hours == 5'd23) ? 5'd0 : (Hours + 5'd1);
        hour_gray <= bin2gray((Hours == 5'd23) ? 5'd0 : (Hours + 5'd1));
    end
end

endmodule