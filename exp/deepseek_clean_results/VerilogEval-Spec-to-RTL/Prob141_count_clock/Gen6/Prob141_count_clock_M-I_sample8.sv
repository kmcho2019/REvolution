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
    reg [4:0] hr_bin;   // 0-23 (for easier PM detection)
    
    // BCD conversion wires
    wire [3:0] ss_high, ss_low;
    wire [3:0] mm_high, mm_low;
    wire [3:0] hh_high, hh_low;
    
    // Clock gating signals
    wire sec_ena = ena;
    wire min_ena = ena && (sec_bin == 6'd59);
    wire hr_ena  = min_ena && (min_bin == 6'd59);

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            sec_bin <= 6'd0;
        end else if (sec_ena) begin
            sec_bin <= (sec_bin == 6'd59) ? 6'd0 : sec_bin + 1;
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            min_bin <= 6'd0;
        end else if (min_ena) begin
            min_bin <= (min_bin == 6'd59) ? 6'd0 : min_bin + 1;
        end
    end

    // Hours counter and PM detection
    always @(posedge clk) begin
        if (reset) begin
            hr_bin <= 5'd0;  // 0 represents 12 AM
            pm_reg <= 1'b0;
        end else if (hr_ena) begin
            if (hr_bin == 5'd23) begin
                hr_bin <= 5'd0;
            end else begin
                hr_bin <= hr_bin + 1;
            end
            // Toggle PM at 12:00 (hr_bin=11->12)
            if (hr_bin == 5'd11) pm_reg <= 1'b1;
            else if (hr_bin == 5'd23) pm_reg <= 1'b0;
        end
    end

    // Binary to BCD conversion for seconds
    assign ss_high = sec_bin / 10;
    assign ss_low  = sec_bin % 10;
    assign ss = {ss_high, ss_low};

    // Binary to BCD conversion for minutes
    assign mm_high = min_bin / 10;
    assign mm_low  = min_bin % 10;
    assign mm = {mm_high, mm_low};

    // Binary to 12-hour BCD conversion for hours
    wire [4:0] hr_12 = (hr_bin == 0) ? 5'd12 : 
                      (hr_bin > 12) ? hr_bin - 12 : hr_bin;
    assign hh_high = hr_12 / 10;
    assign hh_low  = hr_12 % 10;
    assign hh = {hh_high, hh_low};

    assign pm = pm_reg;

endmodule