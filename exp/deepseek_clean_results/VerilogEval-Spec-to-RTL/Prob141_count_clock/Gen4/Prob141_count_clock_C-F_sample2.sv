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

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            {ss_hi, ss_lo} <= 8'h00;
            {mm_hi, mm_lo} <= 8'h00;
            {hh_hi, hh_lo} <= 8'h12;
            pm_reg <= 0;
        end
        else if (ena) begin
            // Seconds counter
            if (ss_lo == 4'd9) begin
                ss_lo <= 0;
                if (ss_hi == 4'd5) begin
                    ss_hi <= 0;
                    
                    // Minutes counter
                    if (mm_lo == 4'd9) begin
                        mm_lo <= 0;
                        if (mm_hi == 4'd5) begin
                            mm_hi <= 0;
                            
                            // Hours counter - optimized logic
                            if ({hh_hi, hh_lo} == 8'h12) begin
                                {hh_hi, hh_lo} <= 8'h01;
                            end
                            else if (hh_lo == 4'd9) begin
                                hh_hi <= 4'd1;
                                hh_lo <= 4'd0;
                            end
                            else begin
                                hh_lo <= hh_lo + 1;
                            end
                            
                            // Toggle PM at 11:59:59 -> 12:00:00
                            if ({hh_hi, hh_lo} == 8'h11) begin
                                pm_reg <= ~pm_reg;
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