module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg pm_reg;
    reg [3:0] hh_high, hh_low;  // BCD digits for hours (1-12)
    reg [3:0] mm_high, mm_low;  // BCD digits for minutes (0-59)
    reg [3:0] ss_high, ss_low;  // BCD digits for seconds (0-59)

    // Assign outputs
    assign pm = pm_reg;
    assign hh = {hh_high, hh_low};
    assign mm = {mm_high, mm_low};
    assign ss = {ss_high, ss_low};

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            hh_high <= 1;
            hh_low <= 2;
            mm_high <= 0;
            mm_low <= 0;
            ss_high <= 0;
            ss_low <= 0;
            pm_reg <= 0;
        end
        else if (ena) begin
            // Seconds counter
            if (ss_low == 9) begin
                ss_low <= 0;
                if (ss_high == 5) begin
                    ss_high <= 0;
                    // Minutes counter
                    if (mm_low == 9) begin
                        mm_low <= 0;
                        if (mm_high == 5) begin
                            mm_high <= 0;
                            // Hours counter
                            if (hh_low == 2 && hh_high == 1) begin
                                // 12 -> 1 transition
                                hh_high <= 0;
                                hh_low <= 1;
                                pm_reg <= ~pm_reg;  // toggle AM/PM
                            end
                            else if (hh_low == 9) begin
                                hh_low <= 0;
                                hh_high <= hh_high + 1;
                            end
                            else begin
                                hh_low <= hh_low + 1;
                            end
                        end
                        else begin
                            mm_high <= mm_high + 1;
                        end
                    end
                    else begin
                        mm_low <= mm_low + 1;
                    end
                end
                else begin
                    ss_high <= ss_high + 1;
                end
            end
            else begin
                ss_low <= ss_low + 1;
            end
        end
    end

endmodule