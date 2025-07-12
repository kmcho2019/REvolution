module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Helper task to increment BCD digit with rollover
    function [3:0] bcd_increment;
        input [3:0] digit;
        input [3:0] limit; // e.g. 9 for seconds units, 5 for seconds tens
        begin
            if (digit == limit)
                bcd_increment = 0;
            else
                bcd_increment = digit + 1;
        end
    endfunction

    // Returns 1 if digit is at limit
    function is_bcd_max;
        input [3:0] digit;
        input [3:0] limit;
        begin
            is_bcd_max = (digit == limit);
        end
    endfunction

    // Convert hh from BCD to 2 digits (hours tens and units)
    // Hours BCD ranges from 0x01 to 0x12 in two BCD digits:
    // hh[7:4] is tens digit (0 or 1)
    // hh[3:0] is units digit (1 to 9 if tens=0, 0 to 2 if tens=1)

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            pm <= 0;
            hh <= 8'h12; // 0x12 BCD for 12
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            // increment seconds BCD
            // first increment units digit of seconds
            if (ss[3:0] == 4'd9) begin
                ss[3:0] <= 4'd0;
                // increment tens digit seconds
                if (ss[7:4] == 4'd5) begin
                    ss[7:4] <= 4'd0;
                    // increment minutes
                    if (mm[3:0] == 4'd9) begin
                        mm[3:0] <= 4'd0;
                        if (mm[7:4] == 4'd5) begin
                            mm[7:4] <= 4'd0;
                            // increment hours BCD from 1 to 12
                            // Decode hours digits
                            if (hh == 8'h12) begin
                                // 12 -> 1
                                hh <= 8'h01;
                                pm <= ~pm; // toggle am/pm on 12->1 rollover
                            end else begin
                                // increment hour by 1 in BCD
                                // We do it carefully for 1..11
                                // hh is BCD: tens hh[7:4], units hh[3:0]
                                if (hh[3:0] == 4'd9) begin
                                    // units digit rollover, increment tens digit
                                    hh[3:0] <= 4'd0;
                                    hh[7:4] <= hh[7:4] + 4'd1;
                                end else begin
                                    hh[3:0] <= hh[3:0] + 4'd1;
                                end
                            end
                        end else begin
                            mm[7:4] <= mm[7:4] + 4'd1;
                        end
                    end else begin
                        mm[3:0] <= mm[3:0] + 4'd1;
                    end
                end else begin
                    ss[7:4] <= ss[7:4] + 4'd1;
                end
            end else begin
                ss[3:0] <= ss[3:0] + 4'd1;
            end
        end
    end

endmodule