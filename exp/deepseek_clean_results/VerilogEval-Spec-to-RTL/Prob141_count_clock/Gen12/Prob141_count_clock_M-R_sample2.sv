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
    wire sec_roll, min_roll;

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_hi <= 4'd0;
            ss_lo <= 4'd0;
        end
        else if (ena) begin
            if (ss_lo == 4'd9) begin
                ss_lo <= 4'd0;
                if (ss_hi == 4'd5)
                    ss_hi <= 4'd0;
                else
                    ss_hi <= ss_hi + 1;
            end
            else begin
                ss_lo <= ss_lo + 1;
            end
        end
    end

    assign sec_roll = (ss_hi == 4'd5) && (ss_lo == 4'd9) && ena;

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_hi <= 4'd0;
            mm_lo <= 4'd0;
        end
        else if (sec_roll) begin
            if (mm_lo == 4'd9) begin
                mm_lo <= 4'd0;
                if (mm_hi == 4'd5)
                    mm_hi <= 4'd0;
                else
                    mm_hi <= mm_hi + 1;
            end
            else begin
                mm_lo <= mm_lo + 1;
            end
        end
    end

    assign min_roll = (mm_hi == 4'd5) && (mm_lo == 4'd9) && sec_roll;

    // Hours and PM counter
    always @(posedge clk) begin
        if (reset) begin
            hh_hi <= 4'd1;
            hh_lo <= 4'd2;
            pm_reg <= 1'b0;
        end
        else if (min_roll) begin
            // Handle hour increment
            if ({hh_hi, hh_lo} == 8'h12) begin
                hh_hi <= 4'd0;
                hh_lo <= 4'd1;
            end
            else if (hh_lo == 4'd9) begin
                hh_hi <= hh_hi + 1;
                hh_lo <= 4'd0;
            end
            else begin
                hh_lo <= hh_lo + 1;
            end

            // Toggle PM at 11:59 -> 12:00 transition
            if ({hh_hi, hh_lo} == 8'h11)
                pm_reg <= ~pm_reg;
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = {ss_hi, ss_lo};
    assign mm = {mm_hi, mm_lo};
    assign hh = {hh_hi, hh_lo};

endmodule