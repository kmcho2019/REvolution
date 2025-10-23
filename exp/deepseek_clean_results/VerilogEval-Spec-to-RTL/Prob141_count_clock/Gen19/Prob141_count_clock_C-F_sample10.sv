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
    reg [3:0] ss_lo, mm_lo, hh_lo;  // BCD low digits
    reg [2:0] ss_hi, mm_hi;         // BCD high digits (0-5)
    reg [0:0] hh_hi;                // Hours high digit (0-1)
    wire sec_roll, min_roll;

    // Rollover signals
    assign sec_roll = (ss_lo == 9) && (ss_hi == 5);
    assign min_roll = sec_roll && (mm_lo == 9) && (mm_hi == 5);

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            {ss_hi, ss_lo} <= 0;
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
            {mm_hi, mm_lo} <= 0;
        end else if (ena && sec_roll) begin
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
            {hh_hi, hh_lo} <= {1'b1, 4'd2}; // 12
            pm_reg <= 0;
        end else if (ena && min_roll) begin
            if ({hh_hi, hh_lo} == {1'b1, 4'd2}) begin // 12
                {hh_hi, hh_lo} <= {1'b0, 4'd1};       // 01
            end else if (hh_lo == 9) begin
                hh_lo <= 0;
                hh_hi <= 1;
            end else begin
                hh_lo <= hh_lo + 1;
                if ({hh_hi, hh_lo} == {1'b1, 4'd1})   // 11
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