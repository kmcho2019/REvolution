module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;    // AM
            hh <= 8'h12;   // 12
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            // Increment seconds
            if (ss == 8'h59) begin
                ss <= 8'h00;
                // Increment minutes
                if (mm == 8'h59) begin
                    mm <= 8'h00;
                    // Increment hours (BCD 01 to 12)
                    if (hh == 8'h12) begin
                        hh <= 8'h01;
                        pm <= ~pm; // toggle pm on rollover from 12 to 1
                    end else begin
                        // Increment BCD hour digit
                        if (hh[3:0] == 4'd9) begin
                            hh <= { (hh[7:4] + 4'd1), 4'd0 };
                        end else begin
                            hh <= { hh[7:4], hh[3:0] + 4'd1 };
                        end
                    end
                end else begin
                    // Increment minutes BCD
                    if (mm[3:0] == 4'd9) begin
                        mm <= { mm[7:4] + 4'd1, 4'd0 };
                    end else begin
                        mm <= { mm[7:4], mm[3:0] + 4'd1 };
                    end
                end
            end else begin
                // Increment seconds BCD
                if (ss[3:0] == 4'd9) begin
                    ss <= { ss[7:4] + 4'd1, 4'd0 };
                end else begin
                    ss <= { ss[7:4], ss[3:0] + 4'd1 };
                end
            end
        end
    end

endmodule