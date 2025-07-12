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
    reg [4:0] hr_bin;   // 0-23 (for easier AM/PM tracking)
    
    // BCD conversion wires
    wire [3:0] ss_high = sec_bin / 10;
    wire [3:0] ss_low = sec_bin % 10;
    wire [3:0] mm_high = min_bin / 10;
    wire [3:0] mm_low = min_bin % 10;
    wire [3:0] hh_high, hh_low;
    
    // Hour conversion logic (12-hour format)
    assign {hh_high, hh_low} = (hr_bin == 0) ? 8'h12 : 
                              (hr_bin <= 9) ? {4'd0, hr_bin[3:0]} : 
                              (hr_bin <= 12) ? {4'd1, hr_bin[3:0] - 4'd10} : 
                              (hr_bin <= 21) ? {4'd0, hr_bin[3:0] - 4'd12} : 
                              {4'd1, hr_bin[3:0] - 4'd22};

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            sec_bin <= 0;
        end else if (ena) begin
            sec_bin <= (sec_bin == 59) ? 0 : sec_bin + 1;
        end
    end

    // Minutes counter (triggered by second rollover)
    always @(posedge clk) begin
        if (reset) begin
            min_bin <= 0;
        end else if (ena && sec_bin == 59) begin
            min_bin <= (min_bin == 59) ? 0 : min_bin + 1;
        end
    end

    // Hours and AM/PM counter (triggered by minute rollover)
    always @(posedge clk) begin
        if (reset) begin
            hr_bin <= 0;  // Maps to 12 AM
            pm_reg <= 0;
        end else if (ena && sec_bin == 59 && min_bin == 59) begin
            if (hr_bin == 23) begin
                hr_bin <= 0;
            end else begin
                hr_bin <= hr_bin + 1;
            end
            // Toggle PM at 11->12 transition
            if (hr_bin == 10) pm_reg <= 1;
            if (hr_bin == 22) pm_reg <= 0;
        end
    end

    assign pm = pm_reg;
    assign hh = {hh_high, hh_low};
    assign mm = {mm_high, mm_low};
    assign ss = {ss_high, ss_low};

endmodule