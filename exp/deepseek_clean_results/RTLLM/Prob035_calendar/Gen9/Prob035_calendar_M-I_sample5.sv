module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,  // Using 6-bit for all counters
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SEC_MIN = 6'd59;
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

// Enable signals
wire sec_rollover = (Secs == MAX_SEC_MIN);
wire min_rollover = (Mins == MAX_SEC_MIN) & sec_rollover;
wire hour_rollover = (Hours == MAX_HOUR) & min_rollover;

// Binary hour counter (for easier arithmetic)
reg [5:0] hours_bin;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        hours_bin <= 6'd0;
    end else begin
        // Seconds counter with clock gating
        if (Secs != MAX_SEC_MIN)
            Secs <= Secs + 1;
        else
            Secs <= 0;

        // Minutes counter with enable
        if (sec_rollover) begin
            if (Mins != MAX_SEC_MIN)
                Mins <= Mins + 1;
            else
                Mins <= 0;
        end

        // Hours counter with enable
        if (min_rollover) begin
            if (hours_bin != MAX_HOUR)
                hours_bin <= hours_bin + 1;
            else
                hours_bin <= 0;
        end
    end
end

// Convert binary hours to Gray code on output
always @(*) begin
    Hours = bin2gray(hours_bin);
end

endmodule