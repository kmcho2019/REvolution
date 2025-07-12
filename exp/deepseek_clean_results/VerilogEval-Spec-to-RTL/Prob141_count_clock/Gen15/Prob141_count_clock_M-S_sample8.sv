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
    reg [3:0] ss_lo, ss_hi;  // seconds: 00-59
    reg [3:0] mm_lo, mm_hi;  // minutes: 00-59
    reg [3:0] hh_lo, hh_hi;  // hours: 01-12

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            {ss_hi, ss_lo} <= 8'h00;
        end else if (ena) begin
            if (ss_lo == 4'h9) begin
                ss_lo <= 4'h0;
                if (ss_hi == 4'h5) begin
                    ss_hi <= 4'h0;
                end else begin
                    ss_hi <= ss_hi + 1;
                end
            end else begin
                ss_lo <= ss_lo + 1;
            end
        end
    end

    // Minutes counter (triggers on second rollover)
    always @(posedge clk) begin
        if (reset) begin
            {mm_hi, mm_lo} <= 8'h00;
        end else if (ena && ss_hi == 4'h5 && ss_lo == 4'h9) begin
            if (mm_lo == 4'h9) begin
                mm_lo <= 4'h0;
                if (mm_hi == 4'h5) begin
                    mm_hi <= 4'h0;
                end else begin
                    mm_hi <= mm_hi + 1;
                end
            end else begin
                mm_lo <= mm_lo + 1;
            end
        end
    end

    // Hours counter (triggers on minute rollover)
    always @(posedge clk) begin
        if (reset) begin
            {hh_hi, hh_lo} <= 8'h12;
            pm_reg <= 1'b0;
        end else if (ena && mm_hi == 4'h5 && mm_lo == 4'h9 && 
                    ss_hi == 4'h5 && ss_lo == 4'h9) begin
            if ({hh_hi, hh_lo} == 8'h12) begin
                {hh_hi, hh_lo} <= 8'h01;
            end else begin
                if (hh_lo == 4'h9) begin
                    {hh_hi, hh_lo} <= {hh_hi + 1, 4'h0};
                end else begin
                    hh_lo <= hh_lo + 1;
                end
            end
            // Toggle PM when going from 11 to 12
            if ({hh_hi, hh_lo} == 8'h11) pm_reg <= ~pm_reg;
        end
    end

    assign pm = pm_reg;
    assign hh = {hh_hi, hh_lo};
    assign mm = {mm_hi, mm_lo};
    assign ss = {ss_hi, ss_lo};

endmodule