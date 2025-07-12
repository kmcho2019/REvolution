module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    reg [7:0] next_ss, next_mm, next_hh;
    reg next_pm;

    always @* begin
        next_ss = ss;
        next_mm = mm;
        next_hh = hh;
        next_pm = pm;

        if (ena) begin
            // Increment seconds BCD (0-59)
            if (ss[3:0] == 4'd9) begin
                if (ss[7:4] == 4'd5) begin
                    next_ss = 8'h00; // rollover 59->00
                    // Increment minutes BCD (0-59)
                    if (mm[3:0] == 4'd9) begin
                        if (mm[7:4] == 4'd5) begin
                            next_mm = 8'h00; // rollover 59->00
                            // Increment hours BCD (1-12)
                            if (hh == 8'h11) begin
                                next_hh = 8'h12;
                                next_pm = ~pm; // toggle am/pm at 11->12
                            end else if (hh == 8'h12) begin
                                next_hh = 8'h01;
                            end else begin
                                // Increment hour BCD by 1
                                if (hh[3:0] == 4'd9)
                                    next_hh = {hh[7:4]+4'd1, 4'd0};
                                else
                                    next_hh = {hh[7:4], hh[3:0]+4'd1};
                            end
                        end else begin
                            next_mm = {mm[7:4]+4'd1, 4'd0};
                        end
                    end else begin
                        next_mm = {mm[7:4], mm[3:0]+4'd1};
                    end
                end else begin
                    next_ss = {ss[7:4]+4'd1, 4'd0};
                end
            end else begin
                next_ss = {ss[7:4], ss[3:0]+4'd1};
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;       // AM
            hh <= 8'h12;      // 12
            mm <= 8'h00;
            ss <= 8'h00;
        end else begin
            pm <= next_pm;
            hh <= next_hh;
            mm <= next_mm;
            ss <= next_ss;
        end
    end

endmodule