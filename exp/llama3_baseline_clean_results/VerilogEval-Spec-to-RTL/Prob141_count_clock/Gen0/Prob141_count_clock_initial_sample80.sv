module TopModule (
    input        clk,
    input        reset,
    input        ena,
    output       pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [7:0] hh_reg;
reg [7:0] mm_reg;
reg [7:0] ss_reg;
reg        pm_reg;

assign hh = hh_reg;
assign mm = mm_reg;
assign ss = ss_reg;
assign pm = pm_reg;

always @(posedge clk) begin
    if (reset) begin
        hh_reg <= 8'b00010001;  // 01 in BCD
        mm_reg <= 8'b00000000;  // 00 in BCD
        ss_reg <= 8'b00000000;  // 00 in BCD
        pm_reg <= 1'b0;         // AM
    end else if (ena) begin
        if (ss_reg == 8'b00000060) begin  // 60 in BCD
            ss_reg <= 8'b00000000;  // 00 in BCD
            if (mm_reg == 8'b00000060) begin  // 60 in BCD
                mm_reg <= 8'b00000000;  // 00 in BCD
                if (hh_reg == 8'b00010001 && pm_reg == 1'b1) begin  // 12 PM
                    hh_reg <= 8'b00010001;  // 01 in BCD
                    pm_reg <= 1'b0;         // AM
                end else if (hh_reg == 8'b00010000 && pm_reg == 1'b0) begin  // 12 AM
                    hh_reg <= 8'b00010001;  // 01 in BCD
                    pm_reg <= 1'b1;         // PM
                end else begin
                    if (hh_reg[3:0] == 4'b1001) begin  // 9 in BCD
                        hh_reg[3:0] <= 4'b0000;  // 0 in BCD
                        hh_reg[7:4] <= hh_reg[7:4] + 1'b1;  // increment tens place
                    end else begin
                        hh_reg[3:0] <= hh_reg[3:0] + 1'b1;  // increment ones place
                    end
                    if (hh_reg == 8'b00010001 && pm_reg == 1'b0) begin  // 01 AM
                        hh_reg <= 8'b00010001;  // 01 in BCD
                        pm_reg <= 1'b1;         // PM
                    end else if (hh_reg == 8'b00010001 && pm_reg == 1'b1) begin  // 01 PM
                        hh_reg <= 8'b00010001;  // 01 in BCD
                        pm_reg <= 1'b0;         // AM
                    end
                end
            end else begin
                if (mm_reg[3:0] == 4'b1001) begin  // 9 in BCD
                    mm_reg[3:0] <= 4'b0000;  // 0 in BCD
                    mm_reg[7:4] <= mm_reg[7:4] + 1'b1;  // increment tens place
                end else begin
                    mm_reg[3:0] <= mm_reg[3:0] + 1'b1;  // increment ones place
                end
            end
        end else begin
            if (ss_reg[3:0] == 4'b1001) begin  // 9 in BCD
                ss_reg[3:0] <= 4'b0000;  // 0 in BCD
                ss_reg[7:4] <= ss_reg[7:4] + 1'b1;  // increment tens place
            end else begin
                ss_reg[3:0] <= ss_reg[3:0] + 1'b1;  // increment ones place
            end
        end
    end
end

endmodule