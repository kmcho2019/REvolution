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
    reg [3:0] ss_hi;  // seconds high digit (0-5)
    reg [3:0] mm_lo;  // minutes low digit (0-9)
    reg [3:0] mm_hi;  // minutes high digit (0-5)
    reg [3:0] hh_lo;  // hours low digit (0-9)
    reg [3:0] hh_hi;  // hours high digit (0-1)

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            {ss_hi, ss_lo} <= 8'h00;
            {mm_hi, mm_lo} <= 8'h00;
            {hh_hi, hh_lo} <= 8'h12;
            pm_reg <= 0;
        end
        else if (ena) begin
            // Seconds increment
            if (ss_lo == 4'd9) begin
                ss_lo <= 0;
                if (ss_hi == 4'd5) begin
                    ss_hi <= 0;
                    // Minutes increment
                    if (mm_lo == 4'd9) begin
                        mm_lo <= 0;
                        if (mm_hi == 4'd5) begin
                            mm_hi <= 0;
                            // Hours increment
                            if (hh_lo == 4'd9) begin
                                hh_lo <= 0;
                                hh_hi <= hh_hi + 1;
                            end
                            else begin
                                hh_lo <= hh_lo + 1;
                            end
                            
                            // Handle 12-hour rollover and PM toggle
                            if ({hh_hi, hh_lo} == 8'h11) begin  // 11 -> 12
                                pm_reg <= ~pm_reg;
                            end
                            else if ({hh_hi, hh_lo} == 8'h12) begin  // 12 -> 1
                                {hh_hi, hh_lo} <= 8'h01;
                            end
                        end
                        else begin
                            mm_hi <= mm_hi + 1;
                        end
                    end
                    else begin
                        mm_lo <= mm_lo + 1;
                    end
                end
                else begin
                    ss_hi <= ss_hi + 1;
                end
            end
            else begin
                ss_lo <= ss_lo + 1;
            end
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = {ss_hi, ss_lo};
    assign mm = {mm_hi, mm_lo};
    assign hh = {hh_hi, hh_lo};

endmodule