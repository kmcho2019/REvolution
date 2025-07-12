module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [7:0] ss_reg;  // seconds in BCD (00-59)
    reg [7:0] mm_reg;  // minutes in BCD (00-59)
    reg [3:0] hh_reg;  // hours (1-12)
    reg pm_reg;        // 0=AM, 1=PM

    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = (hh_reg > 9) ? {4'd1, hh_reg - 4'd10} : {4'd0, hh_reg};

    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
            mm_reg <= 8'h00;
            hh_reg <= 4'd12;
            pm_reg <= 1'b0;
        end
        else if (ena) begin
            // Seconds counter
            if (ss_reg[3:0] == 4'd9) begin
                ss_reg[3:0] <= 4'd0;
                if (ss_reg[7:4] == 4'd5) begin
                    ss_reg[7:4] <= 4'd0;
                    
                    // Minutes counter
                    if (mm_reg[3:0] == 4'd9) begin
                        mm_reg[3:0] <= 4'd0;
                        if (mm_reg[7:4] == 4'd5) begin
                            mm_reg[7:4] <= 4'd0;
                            
                            // Hours counter
                            if (hh_reg == 4'd12) begin
                                hh_reg <= 4'd1;
                                pm_reg <= ~pm_reg;  // Toggle PM at 12:00
                            end else begin
                                hh_reg <= hh_reg + 1;
                            end
                        end else begin
                            mm_reg[7:4] <= mm_reg[7:4] + 1;
                        end
                    end else begin
                        mm_reg[3:0] <= mm_reg[3:0] + 1;
                    end
                end else begin
                    ss_reg[7:4] <= ss_reg[7:4] + 1;
                end
            end else begin
                ss_reg[3:0] <= ss_reg[3:0] + 1;
            end
        end
    end

endmodule