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
    reg [3:0] hh_tens, hh_ones;
    reg [3:0] mm_tens, mm_ones;
    reg [3:0] ss_tens, ss_ones;
    
    wire ss_rollover = (ss_tens == 5) && (ss_ones == 9);
    wire mm_rollover = (mm_tens == 5) && (mm_ones == 9);
    wire hh_rollover = (hh_tens == 1) && (hh_ones == 2);
    
    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_tens <= 0;
            ss_ones <= 0;
        end else if (ena) begin
            if (ss_ones == 9) begin
                ss_ones <= 0;
                ss_tens <= (ss_tens == 5) ? 0 : ss_tens + 1;
            end else begin
                ss_ones <= ss_ones + 1;
            end
        end
    end
    
    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_tens <= 0;
            mm_ones <= 0;
        end else if (ena && ss_rollover) begin
            if (mm_ones == 9) begin
                mm_ones <= 0;
                mm_tens <= (mm_tens == 5) ? 0 : mm_tens + 1;
            end else begin
                mm_ones <= mm_ones + 1;
            end
        end
    end
    
    // Hours counter and PM indicator
    always @(posedge clk) begin
        if (reset) begin
            hh_tens <= 1;
            hh_ones <= 2;
            pm_reg <= 0;
        end else if (ena && ss_rollover && mm_rollover) begin
            if (hh_rollover) begin
                // Toggle PM at 12:00:00
                pm_reg <= ~pm_reg;
                hh_tens <= 1;
                hh_ones <= 2;
            end else if (hh_ones == 9) begin
                hh_ones <= 0;
                hh_tens <= hh_tens + 1;
            end else begin
                hh_ones <= hh_ones + 1;
            end
        end
    end

    assign pm = pm_reg;
    assign hh = {hh_tens, hh_ones};
    assign mm = {mm_tens, mm_ones};
    assign ss = {ss_tens, ss_ones};

endmodule