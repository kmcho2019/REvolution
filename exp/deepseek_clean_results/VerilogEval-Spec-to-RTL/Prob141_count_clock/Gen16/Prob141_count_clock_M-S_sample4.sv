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
    reg [7:0] ss;  // BCD: [7:4] = tens, [3:0] = ones
    reg [7:0] mm;
    reg [7:0] hh;

    always @(posedge clk) begin
        if (reset) begin
            ss <= 8'h00;
            mm <= 8'h00;
            hh <= 8'h12;
            pm_reg <= 1'b0;
        end else if (ena) begin
            // Seconds counter
            if (ss[3:0] == 4'd9) begin
                ss[3:0] <= 4'd0;
                if (ss[7:4] == 4'd5)
                    ss[7:4] <= 4'd0;
                else
                    ss[7:4] <= ss[7:4] + 1;
            end else begin
                ss[3:0] <= ss[3:0] + 1;
            end

            // Minutes counter (on second rollover)
            if (ss == 8'h59) begin
                if (mm[3:0] == 4'd9) begin
                    mm[3:0] <= 4'd0;
                    if (mm[7:4] == 4'd5)
                        mm[7:4] <= 4'd0;
                    else
                        mm[7:4] <= mm[7:4] + 1;
                end else begin
                    mm[3:0] <= mm[3:0] + 1;
                end
            end

            // Hours counter (on minute rollover)
            if (ss == 8'h59 && mm == 8'h59) begin
                if (hh == 8'h12) begin
                    hh <= 8'h01;
                end else if (hh[3:0] == 4'd9) begin
                    hh[3:0] <= 4'd0;
                    hh[7:4] <= hh[7:4] + 1;
                end else begin
                    hh[3:0] <= hh[3:0] + 1;
                end
                
                // PM is high when hour is 12
                pm_reg <= (hh == 8'h11) ? ~pm_reg : pm_reg;
            end
        end
    end

    assign pm = pm_reg;

endmodule