module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [7:0] ss_reg;  // BCD: tens(3:0) and ones(7:4)
    reg [7:0] mm_reg;
    reg [7:0] hh_reg;
    reg pm_reg;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            ss_reg <= 8'h00;
            mm_reg <= 8'h00;
            hh_reg <= 8'h12;
            pm_reg <= 1'b0;
        end else if (ena) begin
            // Seconds increment
            if (ss_reg == 8'h59) begin
                ss_reg <= 8'h00;
                // Minutes increment
                if (mm_reg == 8'h59) begin
                    mm_reg <= 8'h00;
                    // Hours increment
                    if (hh_reg == 8'h12)
                        hh_reg <= 8'h01;
                    else if (hh_reg[3:0] == 4'd9) begin
                        hh_reg[7:4] <= hh_reg[7:4] + 1;
                        hh_reg[3:0] <= 4'd0;
                    end else
                        hh_reg[3:0] <= hh_reg[3:0] + 1;
                    
                    // PM toggle at 11->12
                    if (hh_reg == 8'h11)
                        pm_reg <= ~pm_reg;
                end else if (mm_reg[3:0] == 4'd9) begin
                    mm_reg[7:4] <= mm_reg[7:4] + 1;
                    mm_reg[3:0] <= 4'd0;
                end else
                    mm_reg[3:0] <= mm_reg[3:0] + 1;
            end else if (ss_reg[3:0] == 4'd9) begin
                ss_reg[7:4] <= ss_reg[7:4] + 1;
                ss_reg[3:0] <= 4'd0;
            end else
                ss_reg[3:0] <= ss_reg[3:0] + 1;
        end
    end

    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;
    assign pm = pm_reg;

endmodule