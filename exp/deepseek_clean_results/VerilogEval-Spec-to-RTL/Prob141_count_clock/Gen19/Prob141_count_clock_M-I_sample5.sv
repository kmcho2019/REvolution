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
    reg [7:0] hh_reg;   // BCD: [7:4] = tens, [3:0] = ones (01-12)
    
    // Pre-compute rollover conditions in parallel
    wire ss_max = (ss_reg == 8'h59);
    wire mm_max = (mm_reg == 8'h59);
    wire hh_max = (hh_reg == 8'h12);
    
    wire sec_rollover = ena && ss_max;
    wire min_rollover = ena && ss_max && mm_max;
    wire hour_rollover = ena && ss_max && mm_max && hh_max;

    // Shared BCD increment function
    function [7:0] bcd_inc;
        input [7:0] bcd;
        input max_value;
        begin
            if (bcd[3:0] == 4'd9) begin
                bcd_inc[3:0] = 4'd0;
                bcd_inc[7:4] = (bcd[7:4] == max_value[7:4]) ? 4'd0 : bcd[7:4] + 1;
            end else begin
                bcd_inc = bcd + 1;
            end
        end
    endfunction

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
        end else if (ena) begin
            ss_reg <= bcd_inc(ss_reg, 8'h59);
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end else if (sec_rollover) begin
            mm_reg <= bcd_inc(mm_reg, 8'h59);
        end
    end

    // Hours counter and PM logic
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
            pm_reg <= 1'b0;
        end else if (min_rollover) begin
            if (hh_reg == 8'h12) begin
                hh_reg <= 8'h01;
            end else begin
                hh_reg <= bcd_inc(hh_reg, 8'h12);
            end
            
            // Toggle PM only at 11->12 transition
            if (hh_reg == 8'h11 && min_rollover)
                pm_reg <= ~pm_reg;
        end
    end

    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;
    assign pm = pm_reg;

endmodule