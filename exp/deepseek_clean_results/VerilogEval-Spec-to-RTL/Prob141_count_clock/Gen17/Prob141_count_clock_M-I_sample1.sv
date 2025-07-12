module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Counter registers
    reg [7:0] ss_reg;  // BCD seconds (00-59)
    reg [7:0] mm_reg;  // BCD minutes (00-59)
    reg [7:0] hh_reg;  // BCD hours (01-12)
    reg pm_reg;        // PM indicator

    // Clock gating signals
    wire clk_ena = ena | reset;
    wire clk_gated = clk & clk_ena;

    // Internal enable signals
    wire sec_inc = ena;
    wire min_inc = (ss_reg == 8'h59) & sec_inc;
    wire hour_inc = (mm_reg == 8'h59) & min_inc;

    // Shared BCD increment function
    function [7:0] bcd_inc;
        input [7:0] bcd;
        input [3:0] max_tens;
        begin
            if (bcd[3:0] == 4'h9) begin
                bcd_inc[3:0] = 4'h0;
                bcd_inc[7:4] = (bcd[7:4] == max_tens) ? 4'h0 : bcd[7:4] + 1;
            end else begin
                bcd_inc[3:0] = bcd[3:0] + 1;
                bcd_inc[7:4] = bcd[7:4];
            end
        end
    endfunction

    // Seconds counter (00-59)
    always @(posedge clk_gated) begin
        if (reset) begin
            ss_reg <= 8'h00;
        end else if (sec_inc) begin
            ss_reg <= bcd_inc(ss_reg, 4'h5);
        end
    end

    // Minutes counter (00-59)
    always @(posedge clk_gated) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end else if (min_inc) begin
            mm_reg <= bcd_inc(mm_reg, 4'h5);
        end
    end

    // Hours counter (01-12 in BCD)
    always @(posedge clk_gated) begin
        if (reset) begin
            hh_reg <= 8'h12;
            pm_reg <= 1'b0;
        end else if (hour_inc) begin
            if (hh_reg == 8'h12) begin
                hh_reg <= 8'h01;
            end else if (hh_reg[3:0] == 4'h9) begin
                hh_reg <= {hh_reg[7:4] + 1, 4'h0};
            end else begin
                hh_reg <= hh_reg + 1;
            end
            
            // PM toggles when going from 11->12
            if (hh_reg == 8'h11) pm_reg <= ~pm_reg;
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;

endmodule