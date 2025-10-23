module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Helper function to increment BCD digit with carry
    function [4:0] bcd_inc_digit;
        input [3:0] digit;
        input [3:0] limit;
        begin
            if (digit == limit)
                bcd_inc_digit = {1'b1, 4'd0}; // carry out, digit zero
            else
                bcd_inc_digit = {1'b0, digit + 4'd1}; // no carry
        end
    endfunction

    // Next second digit increment logic
    wire [4:0] sec_low_inc = bcd_inc_digit(ss[3:0], 4'd9);
    wire [4:0] sec_high_inc = bcd_inc_digit(ss[7:4], 4'd5);

    wire sec_carry_low = sec_low_inc[4];
    wire [3:0] sec_next_low = sec_low_inc[3:0];
    wire sec_carry_high = sec_high_inc[4];
    wire [3:0] sec_next_high = sec_high_inc[3:0];

    wire seconds_wrap = (ss == 8'h59);

    wire [7:0] ss_next = seconds_wrap ? 8'h00 :
                        (sec_carry_low ? {sec_high_inc[3:0], 4'd0} : {ss[7:4], sec_next_low});

    // Next minute digit increment logic
    wire [4:0] min_low_inc = bcd_inc_digit(mm[3:0], 4'd9);
    wire [4:0] min_high_inc = bcd_inc_digit(mm[7:4], 4'd5);

    wire min_carry_low = min_low_inc[4];
    wire [3:0] min_next_low = min_low_inc[3:0];
    wire min_carry_high = min_high_inc[4];
    wire [3:0] min_next_high = min_high_inc[3:0];

    wire minutes_wrap = (mm == 8'h59);

    wire [7:0] mm_next = minutes_wrap ? 8'h00 :
                        (min_carry_low ? {min_high_inc[3:0], 4'd0} : {mm[7:4], min_next_low});

    // Next hour increment logic for 12-hour clock in BCD (01-12)
    // We define a function to increment hours with proper BCD rollover and pm toggle

    reg [7:0] hh_next;
    reg pm_next;

    always @* begin
        hh_next = hh;
        pm_next = pm;
        if (minutes_wrap && seconds_wrap && ena) begin
            // increment hours
            if (hh == 8'h12) begin
                hh_next = 8'h01;  // wrap from 12 to 1
            end else if ((hh[7:4] == 4'd0) && (hh[3:0] == 4'd9)) begin
                // 09 -> 10
                hh_next = 8'h10;
            end else begin
                // normal increment units digit
                hh_next[3:0] = hh[3:0] + 4'd1;
                hh_next[7:4] = hh[7:4];
            end
            // toggle pm on 11->12 transition
            if (hh == 8'h11)
                pm_next = ~pm;
        end
    end

    // Sequential update
    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;    // AM
            hh <= 8'h12;   // 12:00 AM
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            if (seconds_wrap) begin
                ss <= 8'h00;
                if (minutes_wrap) begin
                    mm <= 8'h00;
                    hh <= hh_next;
                    pm <= pm_next;
                end else begin
                    mm <= mm_next;
                end
            end else begin
                ss <= ss_next;
            end
        end
    end

endmodule