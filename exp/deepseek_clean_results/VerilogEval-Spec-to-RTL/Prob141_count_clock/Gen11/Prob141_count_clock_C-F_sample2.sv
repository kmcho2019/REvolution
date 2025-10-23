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
    reg [3:0] ss_lo, ss_hi;  // seconds digits (0-5, 0-9)
    reg [3:0] mm_lo, mm_hi;  // minutes digits (0-5, 0-9)
    reg [3:0] hh_lo, hh_hi;  // hours digits (0-1, 0-9)

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_lo <= 0;
            ss_hi <= 0;
        end else if (ena) begin
            if (ss_lo == 4'd9) begin
                ss_lo <= 0;
                ss_hi <= (ss_hi == 4'd5) ? 0 : ss_hi + 1;
            end else begin
                ss_lo <= ss_lo + 1;
            end
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_lo <= 0;
            mm_hi <= 0;
        end else if (ena && ss_lo == 4'd9 && ss_hi == 4'd5) begin
            if (mm_lo == 4'd9) begin
                mm_lo <= 0;
                mm_hi <= (mm_hi == 4'd5) ? 0 : mm_hi + 1;
            end else begin
                mm_lo <= mm_lo + 1;
            end
        end
    end

    // Hours and PM counter
    always @(posedge clk) begin
        if (reset) begin
            hh_lo <= 2;
            hh_hi <= 1;  // 12:00
            pm_reg <= 0;
        end else if (ena && ss_lo == 4'd9 && ss_hi == 4'd5 && mm_lo == 4'd9 && mm_hi == 4'd5) begin
            // Handle hour increment
            if ({hh_hi, hh_lo} == 8'h12) begin
                {hh_hi, hh_lo} <= 8'h01;
            end else if (hh_lo == 4'd9) begin
                hh_hi <= 4'd1;
                hh_lo <= 4'd0;
            end else begin
                hh_lo <= hh_lo + 1;
            end
            
            // Toggle PM at 11->12 transition
            if ({hh_hi, hh_lo} == 8'h11) begin
                pm_reg <= ~pm_reg;
            end
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = {ss_hi, ss_lo};
    assign mm = {mm_hi, mm_lo};
    assign hh = {hh_hi, hh_lo};

endmodule