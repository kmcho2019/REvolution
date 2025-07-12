module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [7:0] ss_reg;  // BCD seconds (00-59)
    reg [7:0] mm_reg;  // BCD minutes (00-59)
    reg [7:0] hh_reg;  // BCD hours (01-12)
    reg pm_reg;        // PM indicator

    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
            mm_reg <= 8'h00;
            hh_reg <= 8'h12;
            pm_reg <= 1'b0;
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

            // Minutes counter (on second rollover)
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

            // Hours counter (on minute rollover)
            if (ss_reg == 8'h59 && mm_reg == 8'h59) begin
                if (hh_reg == 8'h12) begin
                    hh_reg <= 8'h01;
                    pm_reg <= ~pm_reg;  // Toggle AM/PM at 12:00
                end else if (hh_reg[3:0] == 4'h9) begin
                    hh_reg[7:4] <= hh_reg[7:4] + 1;
                    hh_reg[3:0] <= 4'h0;
                end else begin
                    hh_reg[3:0] <= hh_reg[3:0] + 1;
                end
            end
        end
    end

    assign pm = pm_reg;
    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;

endmodule