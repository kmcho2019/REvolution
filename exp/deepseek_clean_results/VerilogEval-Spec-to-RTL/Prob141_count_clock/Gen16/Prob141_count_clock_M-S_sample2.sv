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
    reg [3:0] hour_lo; // hour low digit (0-9)
    reg hour_hi;      // hour high digit (0-1)

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_hi <= 0;
            ss_lo <= 0;
        end else if (ena) begin
            if (ss_lo == 9) begin
                ss_lo <= 0;
                ss_hi <= (ss_hi == 5) ? 0 : ss_hi + 1;
            end else begin
                ss_lo <= ss_lo + 1;
            end
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_hi <= 0;
            mm_lo <= 0;
        end else if (ena && ss_lo == 9 && ss_hi == 5) begin
            if (mm_lo == 9) begin
                mm_lo <= 0;
                mm_hi <= (mm_hi == 5) ? 0 : mm_hi + 1;
            end else begin
                mm_lo <= mm_lo + 1;
            end
        end
    end

    // Hours and PM counter
    always @(posedge clk) begin
        if (reset) begin
            hour <= 12;
            hour_hi <= 1;
            hour_lo <= 2;
            pm_reg <= 0;
        end else if (ena && ss_lo == 9 && ss_hi == 5 && mm_lo == 9 && mm_hi == 5) begin
            if (hour == 12) begin
                hour <= 1;
                hour_hi <= 0;
                hour_lo <= 1;
            end else begin
                hour <= hour + 1;
                if (hour == 11) pm_reg <= ~pm_reg;
                hour_lo <= (hour_lo == 9) ? 0 : hour_lo + 1;
                if (hour_lo == 9) hour_hi <= hour_hi + 1;
            end
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = {ss_hi, ss_lo};
    assign mm = {mm_hi, mm_lo};
    assign hh = {hour_hi, hour_lo};

endmodule