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

    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
            mm_reg <= 8'h00;
            hh_reg <= 8'h12;
            pm_reg <= 1'b0;
        end
        else if (ena) begin
            // Seconds counter
            if (ss_reg == 8'h59) begin
                ss_reg <= 8'h00;
                // Minutes counter
                if (mm_reg == 8'h59) begin
                    mm_reg <= 8'h00;
                    // Hours counter
                    if (hh_reg == 8'h12) begin
                        hh_reg <= 8'h01;
                    end
                    else if (hh_reg == 8'h11) begin
                        hh_reg <= hh_reg + 1;
                        pm_reg <= ~pm_reg;
                    end
                    else begin
                        hh_reg <= hh_reg + 1;
                    end
                end
                else begin
                    // Minute increment
                    if (mm_reg[3:0] == 4'h9) begin
                        mm_reg <= {mm_reg[7:4] + 1, 4'h0};
                    end
                    else begin
                        mm_reg <= mm_reg + 1;
                    end
                end
            end
            else begin
                // Second increment
                if (ss_reg[3:0] == 4'h9) begin
                    ss_reg <= {ss_reg[7:4] + 1, 4'h0};
                end
                else begin
                    ss_reg <= ss_reg + 1;
                end
            end
        end
    end

endmodule