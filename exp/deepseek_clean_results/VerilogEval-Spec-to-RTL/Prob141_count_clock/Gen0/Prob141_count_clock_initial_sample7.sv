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
    reg [3:0] hh_high, hh_low;
    reg [3:0] mm_high, mm_low;
    reg [3:0] ss_high, ss_low;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            pm_reg <= 1'b0;
            hh_high <= 4'd1;
            hh_low <= 4'd2;
            mm_high <= 4'd0;
            mm_low <= 4'd0;
            ss_high <= 4'd0;
            ss_low <= 4'd0;
        end else if (ena) begin
            // Seconds counter
            if (ss_low == 4'd9) begin
                ss_low <= 4'd0;
                if (ss_high == 4'd5) begin
                    ss_high <= 4'd0;
                    // Minutes counter
                    if (mm_low == 4'd9) begin
                        mm_low <= 4'd0;
                        if (mm_high == 4'd5) begin
                            mm_high <= 4'd0;
                            // Hours counter
                            if (hh_low == 4'd2 && hh_high == 4'd1) begin
                                // 12 -> 1
                                hh_high <= 4'd0;
                                hh_low <= 4'd1;
                            end else if (hh_low == 4'd9) begin
                                // 09 -> 10
                                hh_high <= 4'd1;
                                hh_low <= 4'd0;
                            end else begin
                                hh_low <= hh_low + 1;
                            end
                            
                            // Toggle AM/PM when going from 11:59 to 12:00
                            if (hh_high == 4'd1 && hh_low == 4'd1) begin
                                pm_reg <= ~pm_reg;
                            end
                        end else begin
                            mm_high <= mm_high + 1;
                        end
                    end else begin
                        mm_low <= mm_low + 1;
                    end
                end else begin
                    ss_high <= ss_high + 1;
                end
            end else begin
                ss_low <= ss_low + 1;
            end
        end
    end

    assign pm = pm_reg;
    assign hh = {hh_high, hh_low};
    assign mm = {mm_high, mm_low};
    assign ss = {ss_high, ss_low};

endmodule