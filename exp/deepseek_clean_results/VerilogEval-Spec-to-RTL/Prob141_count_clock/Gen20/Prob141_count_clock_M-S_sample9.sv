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
    reg [3:0] ss_lo, mm_lo, hh_lo;
    reg [2:0] ss_hi, mm_hi;
    reg hh_hi;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            {ss_hi, ss_lo} <= 0;
            {mm_hi, mm_lo} <= 0;
            {hh_hi, hh_lo} <= {1'b1, 4'd2}; // 12
            pm_reg <= 0;
        end else if (ena) begin
            // Seconds counter
            if (ss_lo == 9) begin
                ss_lo <= 0;
                ss_hi <= (ss_hi == 5) ? 0 : ss_hi + 1;
            end else begin
                ss_lo <= ss_lo + 1;
            end

            // Minutes counter (on second rollover)
            if (ss_lo == 9 && ss_hi == 5) begin
                if (mm_lo == 9) begin
                    mm_lo <= 0;
                    mm_hi <= (mm_hi == 5) ? 0 : mm_hi + 1;
                end else begin
                    mm_lo <= mm_lo + 1;
                end
            end

            // Hours counter (on minute rollover)
            if (ss_lo == 9 && ss_hi == 5 && mm_lo == 9 && mm_hi == 5) begin
                if ({hh_hi, hh_lo} == {1'b1, 4'd1}) begin // 11 -> 12
                    {hh_hi, hh_lo} <= {1'b1, 4'd2};
                    pm_reg <= ~pm_reg;
                end else if ({hh_hi, hh_lo} == {1'b1, 4'd2}) begin // 12 -> 1
                    {hh_hi, hh_lo} <= {1'b0, 4'd1};
                end else if (hh_lo == 9) begin // 09 -> 10
                    hh_lo <= 0;
                    hh_hi <= 1;
                end else begin
                    hh_lo <= hh_lo + 1;
                end
            end
        end
    end

    assign pm = pm_reg;
    assign ss = {ss_hi, ss_lo};
    assign mm = {mm_hi, mm_lo};
    assign hh = {hh_hi, hh_lo};

endmodule