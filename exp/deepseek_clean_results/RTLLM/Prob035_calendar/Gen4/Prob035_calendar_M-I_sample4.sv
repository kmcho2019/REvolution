module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,  // Changed to 6-bit for uniformity
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

// Internal binary counters
reg [5:0] secs_bin, mins_bin;
wire sec_rollover = (secs_bin == 6'd59);
wire min_rollover = (mins_bin == 6'd59);
wire hour_rollover = (Hours == 6'd23);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        secs_bin <= 6'd0;
        mins_bin <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Seconds counter with gated comparison
        if (secs_bin >= 6'd58) begin
            secs_bin <= (secs_bin == 6'd59) ? 6'd0 : secs_bin + 1;
        end else begin
            secs_bin <= secs_bin + 1;
        end

        // Minutes counter with gated comparison
        if (sec_rollover) begin
            if (mins_bin >= 6'd58) begin
                mins_bin <= (mins_bin == 6'd59) ? 6'd0 : mins_bin + 1;
            end else begin
                mins_bin <= mins_bin + 1;
            end
        end

        // Hours counter
        if (sec_rollover & min_rollover) begin
            Hours <= hour_rollover ? 6'd0 : Hours + 1;
        end
    end
end

// Convert binary counters to Gray code outputs
always @(*) begin
    Secs = bin2gray(secs_bin);
    Mins = bin2gray(mins_bin);
    // Hours remains binary as it changes infrequently
end

endmodule