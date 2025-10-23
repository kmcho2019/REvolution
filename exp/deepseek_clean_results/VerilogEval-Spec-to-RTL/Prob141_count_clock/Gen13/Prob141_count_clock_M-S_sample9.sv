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
    reg [3:0] ss_lo;  // seconds low digit (0-9)
    reg [2:0] ss_hi;  // seconds high digit (0-5)
    reg [3:0] mm_lo;  // minutes low digit (0-9)
    reg [2:0] mm_hi;  // minutes high digit (0-5)
    reg [3:0] hour;   // hours (1-12)
    reg [7:0] hh_reg, mm_reg, ss_reg;

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_lo <= 0;
            ss_hi <= 0;
        end else if (ena) begin
            if (ss_lo == 9) begin
                ss_lo <= 0;
                ss_hi <= (ss_hi == 5) ? 0 : ss_hi + 1;
            end else begin
                ss_lo <= ss_lo + 1;
            end
        end
        ss_reg <= {ss_hi, ss_lo};
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_lo <= 0;
            mm_hi <= 0;
        end else if (ena && ss_lo == 9 && ss_hi == 5) begin
            if (mm_lo == 9) begin
                mm_lo <= 0;
                mm_hi <= (mm_hi == 5) ? 0 : mm_hi + 1;
            end else begin
                mm_lo <= mm_lo + 1;
            end
        end
        mm_reg <= {mm_hi, mm_lo};
    end

    // Hours and PM counter
    always @(posedge clk) begin
        if (reset) begin
            hour <= 12;
            pm_reg <= 0;
        end else if (ena && ss_lo == 9 && ss_hi == 5 && mm_lo == 9 && mm_hi == 5) begin
            if (hour == 12) begin
                hour <= 1;
                pm_reg <= ~pm_reg;
            end else begin
                hour <= hour + 1;
            end
        end
        
        // Direct BCD mapping for hours
        case (hour)
            12: hh_reg <= 8'h12;
            11: hh_reg <= 8'h11;
            10: hh_reg <= 8'h10;
            default: hh_reg <= {4'b0, hour};
        endcase
    end

    assign pm = pm_reg;
    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;

endmodule