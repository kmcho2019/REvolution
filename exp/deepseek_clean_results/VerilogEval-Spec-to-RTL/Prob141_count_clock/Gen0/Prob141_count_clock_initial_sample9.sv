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
    reg [7:0] hh_reg;  // BCD: tens[7:4], ones[3:0]
    reg [7:0] mm_reg;  // BCD: tens[7:4], ones[3:0]
    reg [7:0] ss_reg;  // BCD: tens[7:4], ones[3:0]

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            hh_reg <= 8'h12;
            mm_reg <= 8'h00;
            ss_reg <= 8'h00;
            pm_reg <= 1'b0;
        end
        else if (ena) begin
            // Handle seconds
            if (ss_reg[3:0] == 4'h9) begin
                ss_reg[3:0] <= 4'h0;
                if (ss_reg[7:4] == 4'h5) begin
                    ss_reg[7:4] <= 4'h0;
                    // Seconds roll over, increment minutes
                    if (mm_reg[3:0] == 4'h9) begin
                        mm_reg[3:0] <= 4'h0;
                        if (mm_reg[7:4] == 4'h5) begin
                            mm_reg[7:4] <= 4'h0;
                            // Minutes roll over, increment hours
                            if (hh_reg == 8'h12) begin
                                hh_reg <= 8'h01;
                            end
                            else if (hh_reg[3:0] == 4'h9) begin
                                hh_reg[7:4] <= hh_reg[7:4] + 1;
                                hh_reg[3:0] <= 4'h0;
                            end
                            else begin
                                hh_reg[3:0] <= hh_reg[3:0] + 1;
                            end
                            
                            // Toggle AM/PM at 12:00
                            if (hh_reg == 8'h11) begin
                                pm_reg <= ~pm_reg;
                            end
                        end
                        else begin
                            mm_reg[7:4] <= mm_reg[7:4] + 1;
                        end
                    end
                    else begin
                        mm_reg[3:0] <= mm_reg[3:0] + 1;
                    end
                end
                else begin
                    ss_reg[7:4] <= ss_reg[7:4] + 1;
                end
            end
            else begin
                ss_reg[3:0] <= ss_reg[3:0] + 1;
            end
        end
    end

    assign pm = pm_reg;
    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;

endmodule