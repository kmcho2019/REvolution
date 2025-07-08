module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// BCD digit helpers for increment
function [3:0] bcd_inc_ones;
    input [3:0] digit;
    begin
        if (digit == 4'd9)
            bcd_inc_ones = 4'd0;
        else
            bcd_inc_ones = digit + 4'd1;
    end
endfunction

function [3:0] bcd_inc_tens;
    input [3:0] tens;
    input [3:0] ones;
    input [3:0] max_tens;
    input [3:0] max_ones;
    begin
        if ((tens == max_tens) && (ones == max_ones))
            bcd_inc_tens = 4'd0;
        else if (ones == max_ones)
            bcd_inc_tens = tens + 4'd1;
        else
            bcd_inc_tens = tens;
    end
endfunction

// Extract BCD digits of hh, mm, ss
wire [3:0] ss_ones = ss[3:0];
wire [3:0] ss_tens = ss[7:4];
wire [3:0] mm_ones = mm[3:0];
wire [3:0] mm_tens = mm[7:4];
wire [3:0] hh_ones = hh[3:0];
wire [3:0] hh_tens = hh[7:4];

// Helper to check if ss == 59
wire ss_is_59 = (ss_tens == 4'd5) && (ss_ones == 4'd9);
// Helper to check if mm == 59
wire mm_is_59 = (mm_tens == 4'd5) && (mm_ones == 4'd9);

// Increment seconds logic
reg [7:0] next_ss;
reg [7:0] next_mm;
reg [7:0] next_hh;
reg       next_pm;

always @(*) begin
    // Defaults
    next_ss = ss;
    next_mm = mm;
    next_hh = hh;
    next_pm = pm;

    if (ena) begin
        // Increment seconds
        if (ss_is_59) begin
            next_ss[3:0] = 4'd0;
            next_ss[7:4] = 4'd0;

            // Increment minutes
            if (mm_is_59) begin
                next_mm[3:0] = 4'd0;
                next_mm[7:4] = 4'd0;

                // Increment hours (BCD 12-hour with 01-12)
                // Convert hh to number 1-12
                // We do BCD increment from current hh

                // First check if current hour is 12 (tens=1, ones=2)
                if ((hh_tens == 4'd1) && (hh_ones == 4'd2)) begin
                    // roll over to 01, toggle pm
                    next_hh[7:4] = 4'd0;
                    next_hh[3:0] = 4'd1;
                    next_pm = ~pm;
                end else begin
                    // Increment hour BCD
                    // Hour is from 01 to 11 in BCD or 10, 11, 12
                    // We increment by one, watch for special cases:
                    // 09 -> 10, 10->11, 11->12 handled by BCD increment with constraint

                    // Implement hour increment as BCD decimal increment with special max 12

                    // Convert current hour to decimal for easier logic
                    // But since only 1-12, can do logic:
                    // If ones digit is 9, tens digit increments by 1 and ones=0
                    // Otherwise ones digit increments by 1
                    // But must skip invalid hours >12

                    // Implement increment hour safely:
                    // If hour == 11 (0x11), next hour = 12 (0x12)
                    // If hour == 9 (0x09), next hour = 10 (0x10)
                    // Else if hour < 9, increment ones digit
                    // Else if ones digit is 9, tens + 1 ones=0
                    // Else increment ones digit

                    // To simplify:
                    // We can do decimal increment and then if >12, wrap to 1

                    // Decode to decimal:
                    integer hour_dec;
                    hour_dec = hh_tens * 10 + hh_ones;
                    hour_dec = hour_dec + 1;
                    if (hour_dec > 12)
                        hour_dec = 1;

                    next_hh[7:4] = hour_dec / 10;
                    next_hh[3:0] = hour_dec % 10;
                end
            end else begin
                // Increment minutes BCD
                if (mm_ones == 4'd9) begin
                    next_mm[3:0] = 4'd0;
                    next_mm[7:4] = mm_tens + 4'd1;
                end else begin
                    next_mm[3:0] = mm_ones + 4'd1;
                    next_mm[7:4] = mm_tens;
                end
            end
        end else begin
            // Increment seconds BCD
            if (ss_ones == 4'd9) begin
                next_ss[3:0] = 4'd0;
                next_ss[7:4] = ss_tens + 4'd1;
            end else begin
                next_ss[3:0] = ss_ones + 4'd1;
                next_ss[7:4] = ss_tens;
            end
        end
    end
end

always @(posedge clk) begin
    if (reset) begin
        // 12:00:00 AM
        hh <= 8'h12; // 0x12 BCD for 12
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0;
    end else begin
        hh <= next_hh;
        mm <= next_mm;
        ss <= next_ss;
        pm <= next_pm;
    end
end

endmodule