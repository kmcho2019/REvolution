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
    reg [7:0] ss_reg;  // BCD: [7:4] = tens, [3:0] = ones
    reg [7:0] mm_reg;
    reg [7:0] hh_reg;  // BCD: [7:4] = tens (0 or 1), [3:0] = ones (1-9,0-2)
    
    // Rollover detection (computed in parallel)
    wire sec_max = (ss_reg == 8'h59);
    wire min_max = (mm_reg == 8'h59);
    wire sec_rollover = ena && sec_max;
    wire min_rollover = sec_rollover && min_max;
    wire hour_rollover = min_rollover && (hh_reg == 8'h11 || hh_reg == 8'h12);

    // Shared BCD increment logic
    function [7:0] bcd_inc;
        input [7:0] val;
        input rollover;
        begin
            if (rollover) begin
                if (val[3:0] == 4'd9) begin
                    bcd_inc = {val[7:4] + 4'd1, 4'd0};
                end else begin
                    bcd_inc = {val[7:4], val[3:0] + 4'd1};
                end
            end else begin
                bcd_inc = val;
            end
        end
    endfunction

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
        end else if (ena) begin
            ss_reg <= bcd_inc(ss_reg, 1'b1);
            if (sec_max) ss_reg <= 8'h00;
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end else if (sec_rollover) begin
            mm_reg <= bcd_inc(mm_reg, 1'b1);
            if (min_max) mm_reg <= 8'h00;
        end
    end

    // Hours counter and PM logic
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
            pm_reg <= 1'b0;
        end else if (min_rollover) begin
            if (hh_reg == 8'h12)
                hh_reg <= 8'h01;
            else if (hh_reg == 8'h09)
                hh_reg <= 8'h10;
            else
                hh_reg <= bcd_inc(hh_reg, 1'b1);
            
            // Toggle PM only at 11->12 transition
            if (hh_reg == 8'h11 && hour_rollover)
                pm_reg <= ~pm_reg;
        end
    end

    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;
    assign pm = pm_reg;

endmodule