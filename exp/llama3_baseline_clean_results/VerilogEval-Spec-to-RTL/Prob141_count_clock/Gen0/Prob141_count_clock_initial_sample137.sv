module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [7:0] hh_reg;
reg [7:0] mm_reg;
reg [7:0] ss_reg;
reg pm_reg;

assign hh = hh_reg;
assign mm = mm_reg;
assign ss = ss_reg;
assign pm = pm_reg;

integer cnt;

always @(posedge clk) begin
    if (reset) begin
        hh_reg <= 8'b00010001; // 12 in BCD
        mm_reg <= 8'b00000000; // 00 in BCD
        ss_reg <= 8'b00000000; // 00 in BCD
        pm_reg <= 1'b0; // AM
        cnt <= 0;
    end else if (ena) begin
        cnt <= cnt + 1;
        if (cnt == 100000000) begin // assuming clk is 100 MHz
            cnt <= 0;
            if (ss_reg == 8'b01011001) begin // 59 in BCD
                ss_reg <= 8'b00000000; // 00 in BCD
                if (mm_reg == 8'b01011001) begin // 59 in BCD
                    mm_reg <= 8'b00000000; // 00 in BCD
                    if (hh_reg == 8'b00010010) begin // 12 in BCD, PM
                        hh_reg <= 8'b00010001; // 01 in BCD
                        pm_reg <= 1'b0; // AM
                    end else if (hh_reg == 8'b00010001) begin // 01 in BCD, AM
                        hh_reg <= 8'b00010010; // 12 in BCD
                        pm_reg <= 1'b1; // PM
                    end else begin
                        if (hh_reg[3:0] == 4'b1001) begin // 9 in BCD
                            hh_reg[3:0] <= 4'b0000; // 0 in BCD
                            hh_reg[7:4] <= hh_reg[7:4] + 1;
                        end else begin
                            hh_reg[3:0] <= hh_reg[3:0] + 1;
                        end
                    end
                end else begin
                    if (mm_reg[3:0] == 4'b1001) begin // 9 in BCD
                        mm_reg[3:0] <= 4'b0000; // 0 in BCD
                        mm_reg[7:4] <= mm_reg[7:4] + 1;
                    end else begin
                        mm_reg[3:0] <= mm_reg[3:0] + 1;
                    end
                end
            end else begin
                if (ss_reg[3:0] == 4'b1001) begin // 9 in BCD
                    ss_reg[3:0] <= 4'b0000; // 0 in BCD
                    ss_reg[7:4] <= ss_reg[7:4] + 1;
                end else begin
                    ss_reg[3:0] <= ss_reg[3:0] + 1;
                end
            end
        end
    end
end

endmodule