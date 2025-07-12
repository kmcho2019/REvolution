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

    // Pre-computed rollover conditions
    wire ss_rollover = (ss_lo == 4'd9) && (ss_hi == 4'd5);
    wire mm_rollover = (mm_lo == 4'd9) && (mm_hi == 4'd5);
    wire hh_rollover = ({hh_hi, hh_lo} == 8'h12);

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            {ss_hi, ss_lo} <= 8'h00;
            {mm_hi, mm_lo} <= 8'h00;
            {hh_hi, hh_lo} <= 8'h12;
            pm_reg <= 0;
        end
        else if (ena) begin
            // Seconds counter with parallel rollover detection
            if (ss_lo == 4'd9) begin
                ss_lo <= 0;
                if (ss_hi == 4'd5) begin
                    ss_hi <= 0;
                    
                    // Minutes counter with parallel rollover detection
                    if (mm_lo == 4'd9) begin
                        mm_lo <= 0;
                        if (mm_hi == 4'd5) begin
                            mm_hi <= 0;
                            
                            // Optimized hour counter with combined PM toggle
                            if (hh_rollover) begin
                                {hh_hi, hh_lo} <= 8'h01;
                            end
                            else if ({hh_hi, hh_lo} == 8'h11) begin
                                {hh_hi, hh_lo} <= 8'h12;
                                pm_reg <= ~pm_reg;
                            end
                            else if (hh_lo == 4'd9) begin
                                hh_hi <= hh_hi + 1;
                                hh_lo <= 0;
                            end
                            else begin
                                hh_lo <= hh_lo + 1;
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