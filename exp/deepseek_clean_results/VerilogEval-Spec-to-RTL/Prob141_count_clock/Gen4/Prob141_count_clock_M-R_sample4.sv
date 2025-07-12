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
    reg [7:0] ss_reg;  // seconds in BCD (hi and lo nibbles)
    reg [7:0] mm_reg;  // minutes in BCD
    reg [7:0] hh_reg;  // hours in BCD

    // BCD increment function for seconds/minutes (00-59)
    function [7:0] inc_bcd_60;
        input [7:0] val;
        reg [3:0] lo, hi;
        begin
            lo = val[3:0];
            hi = val[7:4];
            
            if (lo == 4'd9) begin
                lo = 0;
                hi = (hi == 4'd5) ? 0 : hi + 1;
            end else begin
                lo = lo + 1;
            end
            
            inc_bcd_60 = {hi, lo};
        end
    endfunction

    // BCD increment function for hours (01-12)
    function [7:0] inc_bcd_12;
        input [7:0] val;
        reg [3:0] lo, hi;
        begin
            lo = val[3:0];
            hi = val[7:4];
            
            if (val == 8'h12) begin
                inc_bcd_12 = 8'h01;
            end else if (lo == 4'd9) begin
                inc_bcd_12 = {4'd1, 4'd0};
            end else begin
                inc_bcd_12 = {hi, lo + 1};
            end
        end
    endfunction

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
        end else if (ena) begin
            ss_reg <= inc_bcd_60(ss_reg);
        end
    end

    // Minutes counter (triggers on second rollover)
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end else if (ena && ss_reg == 8'h59) begin
            mm_reg <= inc_bcd_60(mm_reg);
        end
    end

    // Hours counter (triggers on minute rollover)
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
            pm_reg <= 0;
        end else if (ena && ss_reg == 8'h59 && mm_reg == 8'h59) begin
            hh_reg <= inc_bcd_12(hh_reg);
            // Toggle PM when going from 11 to 12
            if (hh_reg == 8'h11) begin
                pm_reg <= ~pm_reg;
            end
        end
    end

    // Continuous output assignments
    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

endmodule