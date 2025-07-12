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

    // Rollover signals
    wire ss_rollover = (ss_hi == 4'd5) && (ss_lo == 4'd9);
    wire mm_rollover = (mm_hi == 4'd5) && (mm_lo == 4'd9);
    wire hh_rollover = (hh_hi == 4'd1) && (hh_lo == 4'd1);

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_hi <= 0;
            ss_lo <= 0;
        end
        else if (ena) begin
            if (ss_lo == 4'd9) begin
                ss_lo <= 0;
                ss_hi <= (ss_hi == 4'd5) ? 0 : ss_hi + 1;
            end
            else begin
                ss_lo <= ss_lo + 1;
            end
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_hi <= 0;
            mm_lo <= 0;
        end
        else if (ena && ss_rollover) begin
            if (mm_lo == 4'd9) begin
                mm_lo <= 0;
                mm_hi <= (mm_hi == 4'd5) ? 0 : mm_hi + 1;
            end
            else begin
                mm_lo <= mm_lo + 1;
            end
        end
    end

    // Hours counter
    always @(posedge clk) begin
        if (reset) begin
            hh_hi <= 1;
            hh_lo <= 2;
        end
        else if (ena && ss_rollover && mm_rollover) begin
            if (hh_lo == 4'd9) begin
                hh_lo <= 0;
                hh_hi <= 1;
            end
            else if ({hh_hi, hh_lo} == 8'h12) begin
                hh_lo <= 1;
                hh_hi <= 0;
            end
            else begin
                hh_lo <= hh_lo + 1;
            end
        end
    end

    // PM indicator
    always @(posedge clk) begin
        if (reset) begin
            pm_reg <= 0;
        end
        else if (ena && ss_rollover && mm_rollover && hh_rollover) begin
            pm_reg <= ~pm_reg;
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = {ss_hi, ss_lo};
    assign mm = {mm_hi, mm_lo};
    assign hh = {hh_hi, hh_lo};

endmodule