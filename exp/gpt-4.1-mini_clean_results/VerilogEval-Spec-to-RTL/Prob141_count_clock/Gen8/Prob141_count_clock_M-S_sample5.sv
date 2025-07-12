module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Function: increment BCD 00-59 counter
    function [7:0] bcd_inc_59;
        input [7:0] val;
        reg [3:0] tens, ones;
        begin
            tens = val[7:4];
            ones = val[3:0];
            if (ones == 4'd9) begin
                ones = 4'd0;
                if (tens == 4'd5)
                    tens = 4'd0;
                else
                    tens = tens + 4'd1;
            end else begin
                ones = ones + 4'd1;
            end
            bcd_inc_59 = {tens, ones};
        end
    endfunction

    // Function: increment 12-hour BCD hh (01-12)
    function [7:0] bcd_inc_12;
        input [7:0] val;
        reg [3:0] tens, ones;
        begin
            tens = val[7:4];
            ones = val[3:0];
            if ((val == 8'h12)) begin
                // wrap 12 to 1
                bcd_inc_12 = 8'h01;
            end else if (ones == 4'd9) begin
                ones = 4'd0;
                tens = tens + 4'd1;
                bcd_inc_12 = {tens, ones};
            end else begin
                ones = ones + 4'd1;
                bcd_inc_12 = {tens, ones};
            end
        end
    endfunction

    wire ss_is_59 = (ss == 8'h59);
    wire mm_is_59 = (mm == 8'h59);
    wire hh_is_11 = (hh == 8'h11);

    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;     // AM
            hh <= 8'h12;    // 12
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            if (ss_is_59) begin
                ss <= 8'h00;
                if (mm_is_59) begin
                    mm <= 8'h00;
                    if (hh == 8'h12) begin
                        hh <= 8'h01;
                    end else begin
                        hh <= bcd_inc_12(hh);
                    end
                    if (hh_is_11)
                        pm <= ~pm;
                end else begin
                    mm <= bcd_inc_59(mm);
                end
            end else begin
                ss <= bcd_inc_59(ss);
            end
        end
    end

endmodule