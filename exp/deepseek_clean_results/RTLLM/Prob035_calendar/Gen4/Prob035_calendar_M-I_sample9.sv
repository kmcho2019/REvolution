module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Gray code conversion functions
function [5:0] bin2gray(input [5:0] b);
    bin2gray = {b[5], b[5:1] ^ b[4:0]};
endfunction

function [5:0] gray2bin(input [5:0] g);
    gray2bin = {g[5], g[4] ^ gray2bin[5], g[3] ^ gray2bin[4],
                g[2] ^ gray2bin[3], g[1] ^ gray2bin[2], g[0] ^ gray2bin[1]};
endfunction

// Internal binary counters
reg [5:0] sec_bin, min_bin, hour_bin;
wire sec_roll = (sec_bin == 6'd59);
wire min_roll = (min_bin == 6'd59);
wire hour_roll = (hour_bin == 6'd23);

// Gated comparison enables
wire sec_check_en = (sec_bin >= 6'd58);
wire min_check_en = (min_bin >= 6'd58) & sec_roll;
wire hour_check_en = (hour_bin >= 6'd22) & min_roll & sec_roll;

// Clock gating signals
wire hour_update_en = sec_roll & min_roll;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        sec_bin <= 6'd0;
        min_bin <= 6'd0;
        hour_bin <= 6'd0;
    end else begin
        // Seconds counter (Gray coded)
        if (sec_roll) begin
            sec_bin <= 6'd0;
        end else begin
            sec_bin <= sec_bin + 6'd1;
        end

        // Minutes counter (Gray coded)
        if (sec_roll) begin
            if (min_roll) begin
                min_bin <= 6'd0;
            end else begin
                min_bin <= min_bin + 6'd1;
            end
        end

        // Hours counter (clock gated)
        if (hour_update_en) begin
            if (hour_roll) begin
                hour_bin <= 6'd0;
            end else begin
                hour_bin <= hour_bin + 6'd1;
            end
        end
    end
end

// Convert binary counters to Gray code outputs
always @(*) begin
    Secs = bin2gray(sec_bin);
    Mins = bin2gray(min_bin);
    Hours = hour_bin; // Hours remains binary for simpler comparison
end

endmodule