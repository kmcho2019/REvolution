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
    reg [3:0] ss_lo, mm_lo, hh_lo;  // lower BCD digits (0-9)
    reg [2:0] ss_hi, mm_hi;         // upper BCD digits (0-5)
    reg hh_hi;                      // hour tens digit (0-1)

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            ss_hi <= 0; ss_lo <= 0;
            mm_hi <= 0; mm_lo <= 0;
            hh_hi <= 1; hh_lo <= 2;  // 12
            pm_reg <= 0;
        end else if (ena) begin
            // Seconds counter
            if (ss_lo == 9) begin
                ss_lo <= 0;
                ss_hi <= (ss_hi == 5) ? 0 : ss_hi + 1;
            end else begin
                ss_lo <= ss_lo + 1;
            end

            // Minutes counter (on seconds rollover)
            if (ss_lo == 9 && ss_hi == 5) begin
                if (mm_lo == 9) begin
                    mm_lo <= 0;
                    mm_hi <= (mm_hi == 5) ? 0 : mm_hi + 1;
                end else begin
                    mm_lo <= mm_lo + 1;
                end
            end

            // Hours counter (on minutes and seconds rollover)
            if (ss_lo == 9 && ss_hi == 5 && mm_lo == 9 && mm_hi == 5) begin
                case ({hh_hi, hh_lo})
                    {1'b1, 4'd1}: begin  // 11 → 12
                        hh_hi <= 1; hh_lo <= 2;
                        pm_reg <= ~pm_reg;
                    end
                    {1'b1, 4'd2}: begin  // 12 → 1
                        hh_hi <= 0; hh_lo <= 1;
                    end
                    default: begin
                        if (hh_lo == 9) begin  // 9 → 10
                            hh_hi <= 1; hh_lo <= 0;
                        end else begin
                            hh_lo <= hh_lo + 1;
                        end
                    end
                endcase
            end
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = {ss_hi, ss_lo};
    assign mm = {mm_hi, mm_lo};
    assign hh = {hh_hi, hh_lo};

endmodule