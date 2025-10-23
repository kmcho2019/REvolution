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
    reg [3:0] hh_high, hh_low;  // hours digits (1-12)
    reg [3:0] mm_high, mm_low;  // minutes digits (00-59)
    reg [3:0] ss_high, ss_low;  // seconds digits (00-59)

    // Assign outputs
    assign pm = pm_reg;
    assign hh = {hh_high, hh_low};
    assign mm = {mm_high, mm_low};
    assign ss = {ss_high, ss_low};

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            pm_reg <= 1'b0;
            hh_high <= 4'b0001;
            hh_low <= 4'b0010;
            mm_high <= 4'b0000;
            mm_low <= 4'b0000;
            ss_high <= 4'b0000;
            ss_low <= 4'b0000;
        end
        else if (ena) begin
            // Seconds counter
            if (ss_low == 4'b1001) begin
                ss_low <= 4'b0000;
                if (ss_high == 4'b0101) begin
                    ss_high <= 4'b0000;
                    // Minute increment
                    if (mm_low == 4'b1001) begin
                        mm_low <= 4'b0000;
                        if (mm_high == 4'b0101) begin
                            mm_high <= 4'b0000;
                            // Hour increment
                            if (hh_low == 4'b0010 && hh_high == 4'b0001) begin  // 12
                                if (pm_reg) begin
                                    pm_reg <= 1'b0;  // PM->AM
                                    hh_high <= 4'b0001;
                                    hh_low <= 4'b0001;  // 12->1
                                end
                                else begin
                                    pm_reg <= 1'b1;  // AM->PM
                                    hh_high <= 4'b0001;
                                    hh_low <= 4'b0001;  // 12->1
                                end
                            end
                            else if (hh_low == 4'b1001) begin
                                hh_low <= 4'b0000;
                                hh_high <= hh_high + 1;
                            end
                            else begin
                                hh_low <= hh_low + 1;
                            end
                        end
                        else begin
                            mm_high <= mm_high + 1;
                        end
                    end
                    else begin
                        mm_low <= mm_low + 1;
                    end
                end
                else begin
                    ss_high <= ss_high + 1;
                end
            end
            else begin
                ss_low <= ss_low + 1;
            end
        end
    end

endmodule