module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg  [7:0] hh,
    output reg  [7:0] mm,
    output reg  [7:0] ss
);

    // Seconds counter: BCD digits (00 to 59)
    always @(posedge clk) begin
        if (reset) begin
            ss <= 8'h00; // 00 seconds
        end else if (ena) begin
            if (ss[3:0] == 4'd9) begin
                ss[3:0] <= 4'd0;
                if (ss[7:4] == 4'd5) begin
                    ss[7:4] <= 4'd0;
                end else begin
                    ss[7:4] <= ss[7:4] + 4'd1;
                end
            end else begin
                ss[3:0] <= ss[3:0] + 4'd1;
            end
        end
    end

    // Minutes counter: BCD digits (00 to 59)
    always @(posedge clk) begin
        if (reset) begin
            mm <= 8'h00; // 00 minutes
        end else if (ena && ss == 8'h59) begin
            if (mm[3:0] == 4'd9) begin
                mm[3:0] <= 4'd0;
                if (mm[7:4] == 4'd5) begin
                    mm[7:4] <= 4'd0;
                end else begin
                    mm[7:4] <= mm[7:4] + 4'd1;
                end
            end else begin
                mm[3:0] <= mm[3:0] + 4'd1;
            end
        end
    end

    // Hours counter: BCD digits (01 to 12)
    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'h12; // 12 hours
            pm <= 1'b0;  // AM
        end else if (ena && mm == 8'h59 && ss == 8'h59) begin
            if (hh == 8'h11) begin
                hh <= 8'h12;
                pm <= ~pm;  // Toggle PM at 12
            end else if (hh == 8'h12) begin
                hh <= 8'h01;
            end else begin
                // Increment hour by 1 in BCD
                if (hh[3:0] == 4'd9) begin
                    hh[3:0] <= 4'd0;
                    hh[7:4] <= hh[7:4] + 4'd1;
                end else begin
                    hh[3:0] <= hh[3:0] + 4'd1;
                end
            end
        end
    end

endmodule