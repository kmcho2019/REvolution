module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // BCD counters (all directly in BCD format)
    reg [7:0] ss;  // seconds (00-59)
    reg [7:0] mm;  // minutes (00-59)
    reg [7:0] hh;  // hours (01-12)

    // Combinational PM indicator
    assign pm = (hh[7:4] == 4'd1 && hh[3:0] >= 4'd2) || 
                (hh[7:4] == 4'd0 && hh[3:0] >= 4'd12);

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            ss <= 8'h00;
            mm <= 8'h00;
            hh <= 8'h12;
        end
        else if (ena) begin
            // Seconds increment
            if (ss[3:0] == 4'h9) begin
                ss[3:0] <= 4'h0;
                if (ss[7:4] == 4'h5)
                    ss[7:4] <= 4'h0;
                else
                    ss[7:4] <= ss[7:4] + 1;
            end
            else begin
                ss[3:0] <= ss[3:0] + 1;
            end

            // Minutes increment (only when seconds roll over)
            if (ss == 8'h59) begin
                if (mm[3:0] == 4'h9) begin
                    mm[3:0] <= 4'h0;
                    if (mm[7:4] == 4'h5)
                        mm[7:4] <= 4'h0;
                    else
                        mm[7:4] <= mm[7:4] + 1;
                end
                else begin
                    mm[3:0] <= mm[3:0] + 1;
                end
            end

            // Hours increment (only when minutes roll over)
            if (ss == 8'h59 && mm == 8'h59) begin
                if (hh == 8'h12)
                    hh <= 8'h01;
                else if (hh[3:0] == 4'h9) begin
                    hh[3:0] <= 4'h0;
                    hh[7:4] <= hh[7:4] + 1;
                end
                else begin
                    hh[3:0] <= hh[3:0] + 1;
                end
            end
        end
    end

endmodule