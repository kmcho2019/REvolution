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
    reg [5:0] sec_bin;  // 0-59
    reg [5:0] min_bin;  // 0-59
    reg [4:0] hr_bin;   // 0-23 (for easier AM/PM handling)
    
    // BCD conversion wires
    wire [3:0] ss_high = sec_bin / 10;
    wire [3:0] ss_low  = sec_bin % 10;
    wire [3:0] mm_high = min_bin / 10;
    wire [3:0] mm_low  = min_bin % 10;
    wire [3:0] hh_high, hh_low;
    
    // Seconds counter
    always @(posedge clk) begin
        if (reset) sec_bin <= 0;
        else if (ena) begin
            sec_bin <= (sec_bin == 59) ? 0 : sec_bin + 1;
        end
    end
    
    // Minutes counter (triggered by second rollover)
    wire min_inc = ena && (sec_bin == 59);
    always @(posedge clk) begin
        if (reset) min_bin <= 0;
        else if (min_inc) begin
            min_bin <= (min_bin == 59) ? 0 : min_bin + 1;
        end
    end
    
    // Hours counter (triggered by minute rollover)
    wire hr_inc = min_inc && (min_bin == 59);
    always @(posedge clk) begin
        if (reset) begin
            hr_bin <= 0;  // Will be converted to 12 AM
            pm_reg <= 0;
        end
        else if (hr_inc) begin
            if (hr_bin == 23) begin
                hr_bin <= 0;
                pm_reg <= 0;
            end else begin
                hr_bin <= hr_bin + 1;
                if (hr_bin == 11) pm_reg <= 1;
            end
        end
    end
    
    // Convert 24-hour to 12-hour BCD
    assign hh_high = (hr_bin == 0)           ? 1 :  // 0 -> 12 AM
                    (hr_bin < 10)           ? 0 :  // 1-9 -> 01-09
                    (hr_bin < 12)           ? 1 :  // 10-11 -> 10-11
                    (hr_bin == 12)          ? 1 :  // 12 PM
                    (hr_bin < 22)           ? 0 :  // 13-21 -> 01-09
                    1;                             // 22-23 -> 10-11
    assign hh_low = (hr_bin == 0)            ? 2 :  // 0 -> 12
                   (hr_bin < 10)           ? hr_bin : 
                   (hr_bin < 12)           ? hr_bin - 10 :
                   (hr_bin == 12)           ? 2 :
                   (hr_bin < 22)            ? hr_bin - 12 :
                   hr_bin - 22;
    
    assign pm = pm_reg;
    assign hh = {hh_high, hh_low};
    assign mm = {mm_high, mm_low};
    assign ss = {ss_high, ss_low};

endmodule