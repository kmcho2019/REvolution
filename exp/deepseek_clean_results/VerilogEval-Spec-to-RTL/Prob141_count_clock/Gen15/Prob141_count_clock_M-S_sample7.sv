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
    reg [3:0] ss_lo, ss_hi;  // seconds digits
    reg [3:0] mm_lo, mm_hi;  // minutes digits
    reg [3:0] hh_lo, hh_hi;  // hours digits

    // Seconds counter
    always @(posedge clk) begin
        if (reset) {ss_hi, ss_lo} <= 8'h00;
        else if (ena) begin
            if (ss_lo == 9) begin
                ss_lo <= 0;
                ss_hi <= (ss_hi == 5) ? 0 : ss_hi + 1;
            end
            else ss_lo <= ss_lo + 1;
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) {mm_hi, mm_lo} <= 8'h00;
        else if (ena && ss_lo == 9 && ss_hi == 5) begin
            if (mm_lo == 9) begin
                mm_lo <= 0;
                mm_hi <= (mm_hi == 5) ? 0 : mm_hi + 1;
            end
            else mm_lo <= mm_lo + 1;
        end
    end

    // Hours counter and PM indicator
    always @(posedge clk) begin
        if (reset) begin
            {hh_hi, hh_lo} <= 8'h12;
            pm_reg <= 0;
        end
        else if (ena && ss_lo == 9 && ss_hi == 5 && mm_lo == 9 && mm_hi == 5) begin
            if ({hh_hi, hh_lo} == 8'h12) begin
                {hh_hi, hh_lo} <= 8'h01;
            end
            else if (hh_lo == 9) begin
                {hh_hi, hh_lo} <= {hh_hi + 1, 4'd0};
            end
            else begin
                hh_lo <= hh_lo + 1;
            end

            // Toggle PM at 11:59:59 -> 12:00:00
            if ({hh_hi, hh_lo} == 8'h11) pm_reg <= ~pm_reg;
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = {ss_hi, ss_lo};
    assign mm = {mm_hi, mm_lo};
    assign hh = {hh_hi, hh_lo};

endmodule