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
    reg [7:0] ss_reg;  // BCD seconds (00-59)
    reg [7:0] mm_reg;  // BCD minutes (00-59)
    reg [7:0] hh_reg;  // BCD hours (01-12)

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            ss_reg <= 8'h00;
            mm_reg <= 8'h00;
            hh_reg <= 8'h12;
            pm_reg <= 0;
        end else if (ena) begin
            // Seconds counter
            if (ss_reg[3:0] == 4'h9) begin
                ss_reg[3:0] <= 4'h0;
                if (ss_reg[7:4] == 4'h5)
                    ss_reg[7:4] <= 4'h0;
                else
                    ss_reg[7:4] <= ss_reg[7:4] + 1;
            end else begin
                ss_reg[3:0] <= ss_reg[3:0] + 1;
            end

            // Minutes counter (on seconds rollover)
            if (ss_reg == 8'h59) begin
                if (mm_reg[3:0] == 4'h9) begin
                    mm_reg[3:0] <= 4'h0;
                    if (mm_reg[7:4] == 4'h5)
                        mm_reg[7:4] <= 4'h0;
                    else
                        mm_reg[7:4] <= mm_reg[7:4] + 1;
                end else begin
                    mm_reg[3:0] <= mm_reg[3:0] + 1;
                end
            end

            // Hours counter (on minutes and seconds rollover)
            if (ss_reg == 8'h59 && mm_reg == 8'h59) begin
                if (hh_reg == 8'h11) begin
                    hh_reg <= 8'h12;
                    pm_reg <= ~pm_reg;
                end else if (hh_reg == 8'h12) begin
                    hh_reg <= 8'h01;
                end else if (hh_reg[3:0] == 4'h9) begin
                    hh_reg[3:0] <= 4'h0;
                    hh_reg[7:4] <= hh_reg[7:4] + 1;
                end else begin
                    hh_reg[3:0] <= hh_reg[3:0] + 1;
                end
            end
        end
    end

    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

endmodule