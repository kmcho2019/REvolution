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
    reg [3:0] ss_lo, ss_hi;
    reg [3:0] mm_lo, mm_hi;
    reg [3:0] hh_lo, hh_hi;

    always @(posedge clk) begin
        if (reset) begin
            {ss_hi, ss_lo} <= 8'h00;
            {mm_hi, mm_lo} <= 8'h00;
            {hh_hi, hh_lo} <= 8'h12;
            pm_reg <= 0;
        end
        else if (ena) begin
            // Seconds counter
            if ({ss_hi, ss_lo} == 8'h59) begin
                {ss_hi, ss_lo} <= 8'h00;
                
                // Minutes counter
                if ({mm_hi, mm_lo} == 8'h59) begin
                    {mm_hi, mm_lo} <= 8'h00;
                    
                    // Hours counter
                    if ({hh_hi, hh_lo} == 8'h12) begin
                        {hh_hi, hh_lo} <= 8'h01;
                    end
                    else begin
                        if (hh_lo == 4'd9) begin
                            {hh_hi, hh_lo} <= {hh_hi + 1, 4'h0};
                        end
                        else begin
                            hh_lo <= hh_lo + 1;
                        end
                    end
                    
                    // Toggle PM at 11->12 transition
                    if ({hh_hi, hh_lo} == 8'h11) pm_reg <= ~pm_reg;
                end
                else begin
                    if (mm_lo == 4'd9) begin
                        {mm_hi, mm_lo} <= {mm_hi + 1, 4'h0};
                    end
                    else begin
                        mm_lo <= mm_lo + 1;
                    end
                end
            end
            else begin
                if (ss_lo == 4'd9) begin
                    {ss_hi, ss_lo} <= {ss_hi + 1, 4'h0};
                end
                else begin
                    ss_lo <= ss_lo + 1;
                end
            end
        end
    end

    assign pm = pm_reg;
    assign ss = {ss_hi, ss_lo};
    assign mm = {mm_hi, mm_lo};
    assign hh = {hh_hi, hh_lo};

endmodule