module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // BCD digits for seconds, minutes, hours
    reg [3:0] ss_low, ss_high;  // seconds: 0-59
    reg [3:0] mm_low, mm_high;  // minutes: 0-59
    reg [3:0] hh_low, hh_high;  // hours: 1-12 in BCD

    // Helper: Convert hh_high/hh_low to integer hour
    // We'll store hours as BCD (1-12) - hh_high is tens digit (0 or 1), hh_low is units (0-9)
    // On reset: 12 => hh_high=1, hh_low=2

    always @(posedge clk) begin
        if (reset) begin
            // reset to 12:00:00 AM
            pm <= 1'b0;
            ss_low <= 4'd0;
            ss_high <= 4'd0;
            mm_low <= 4'd0;
            mm_high <= 4'd0;
            hh_low <= 4'd2;  // 12
            hh_high <= 4'd1;
        end else if (ena) begin
            // increment seconds
            if (ss_low == 4'd9) begin
                ss_low <= 4'd0;
                if (ss_high == 4'd5) begin
                    ss_high <= 4'd0;
                    // increment minutes
                    if (mm_low == 4'd9) begin
                        mm_low <= 4'd0;
                        if (mm_high == 4'd5) begin
                            mm_high <= 4'd0;
                            // increment hour
                            // current hour in BCD: hh_high * 10 + hh_low
                            if (hh_high == 4'd1 && hh_low == 4'd2) begin
                                // hour = 12, roll over to 1, toggle pm
                                hh_high <= 4'd0;
                                hh_low <= 4'd1;
                                pm <= ~pm;
                            end else if (hh_low == 4'd9) begin
                                // if low digit is 9, increment high digit
                                hh_low <= 4'd0;
                                hh_high <= hh_high + 4'd1;
                            end else begin
                                // just increment low digit
                                hh_low <= hh_low + 4'd1;
                            end
                        end else begin
                            mm_high <= mm_high + 4'd1;
                        end
                    end else begin
                        mm_low <= mm_low + 4'd1;
                    end
                end else begin
                    ss_high <= ss_high + 4'd1;
                end
            end else begin
                ss_low <= ss_low + 4'd1;
            end
        end
    end

    // Output BCD assignments
    always @* begin
        hh = {hh_high, hh_low};
        mm = {mm_high, mm_low};
        ss = {ss_high, ss_low};
    end

endmodule