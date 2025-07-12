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
    reg [3:0] hh_high, hh_low;
    reg [3:0] mm_high, mm_low;
    reg [3:0] ss_high, ss_low;

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
        end else if (ena) begin
            // Handle seconds counter
            if (ss_low == 9) begin
                ss_low <= 0;
                if (ss_high == 5) begin
                    ss_high <= 0;
                    // Seconds rollover, increment minutes
                    if (mm_low == 9) begin
                        mm_low <= 0;
                        if (mm_high == 5) begin
                            mm_high <= 0;
                            // Minutes rollover, increment hours
                            if (hh_low == 2 && hh_high == 1) begin
                                // 12 -> 1
                                hh_high <= 0;
                                hh_low <= 1;
                                pm_reg <= ~pm_reg; // Toggle AM/PM at 12:00
                            end else if (hh_low == 9) begin
                                // 09 -> 10, 19 -> 20 (but we don't have 20)
                                hh_high <= hh_high + 1;
                                hh_low <= 0;
                            end else begin
                                // Normal increment
                                hh_low <= hh_low + 1;
                                // Check for 11->12 transition
                                if (hh_high == 1 && hh_low == 1) begin
                                    hh_high <= 1;
                                    hh_low <= 2;
                                end
                            end
                        end else begin
                            mm_high <= mm_high + 1;
                        end
                    end else begin
                        mm_low <= mm_low + 1;
                    end
                end else begin
                    ss_high <= ss_high + 1;
                end
            end else begin
                ss_low <= ss_low + 1;
            end
        end
    end

    assign pm = pm_reg;
    assign hh = {hh_high, hh_low};
    assign mm = {mm_high, mm_low};
    assign ss = {ss_high, ss_low};

endmodule