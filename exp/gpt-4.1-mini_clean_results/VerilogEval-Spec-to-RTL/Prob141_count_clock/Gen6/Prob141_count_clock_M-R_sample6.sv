module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Check if BCD value equals 59 (for mm, ss)
    wire ss_is_59 = (ss == 8'h59);
    wire mm_is_59 = (mm == 8'h59);

    // Check if hour is 11 (for PM toggle detection)
    wire hh_is_11 = (hh == 8'h11);

    // Function to increment BCD digit with limit (for single digits)
    function [3:0] inc_bcd_digit;
        input [3:0] digit;
        input [3:0] limit;
        begin
            if (digit == limit)
                inc_bcd_digit = 4'd0;
            else
                inc_bcd_digit = digit + 4'd1;
        end
    endfunction

    // Combinational logic to increment seconds in BCD (00-59)
    wire [7:0] next_ss = (ss_is_59) ? 8'h00 : (
        (ss[3:0] == 4'd9) ? {inc_bcd_digit(ss[7:4],4'd5), 4'd0} : {ss[7:4], ss[3:0]+4'd1}
    );

    // Combinational logic to increment minutes in BCD (00-59)
    wire [7:0] next_mm = (mm_is_59) ? 8'h00 : (
        (mm[3:0] == 4'd9) ? {inc_bcd_digit(mm[7:4],4'd5), 4'd0} : {mm[7:4], mm[3:0]+4'd1}
    );

    // Combinational logic to increment hours in 12-hour BCD (01-12)
    reg [7:0] next_hh;
    reg next_pm;

    always @* begin
        // Default next values = current
        next_hh = hh;
        next_pm = pm;

        if (ss_is_59 && ena) begin
            // Seconds roll over, increment minutes
            if (mm_is_59) begin
                // Minutes roll over, increment hour
                if (hh == 8'h12) begin
                    // Hours roll over from 12 to 1
                    next_hh = 8'h01;
                end else if ((hh[3:0] == 4'd9) && (hh[7:4] == 4'd0)) begin
                    // If units digit 9 and tens digit 0 (e.g., 09), increment tens digit to 1 and units to 0 (10)
                    next_hh = 8'h10;
                end else begin
                    // Regular increment of hours BCD
                    next_hh[3:0] = hh[3:0] + 4'd1;
                    next_hh[7:4] = hh[7:4];
                end

                // Toggle pm at 11->12 transition
                if (hh_is_11)
                    next_pm = ~pm;
            end
        end
    end

    // State update block
    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0; // AM
            hh <= 8'h12; // 12
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            if (ss_is_59) begin
                ss <= 8'h00;

                if (mm_is_59) begin
                    mm <= 8'h00;
                    hh <= next_hh;
                    pm <= next_pm;
                end else begin
                    mm <= next_mm;
                end
            end else begin
                ss <= next_ss;
            end
        end
    end

endmodule