module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Increment BCD two digit (00-59)
    function [7:0] bcd_increment_59(input [7:0] bcd);
        reg [3:0] tens;
        reg [3:0] units;
        begin
            tens = bcd[7:4];
            units = bcd[3:0];
            if(units == 4'd9) begin
                units = 4'd0;
                if(tens == 4'd5) begin
                    tens = 4'd0;
                end else begin
                    tens = tens + 1'b1;
                end
            end else begin
                units = units + 1'b1;
            end
            bcd_increment_59 = {tens, units};
        end
    endfunction

    // Increment hour BCD from 01 to 12 with wrap indication
    // Output: next hour BCD and wrap flag indicating hour wrapped from 12 to 1
    function [8:0] bcd_hour_increment(input [7:0] curr_hh);
        reg [3:0] tens;
        reg [3:0] units;
        reg wrap;
        reg [7:0] next_hh;
        begin
            tens = curr_hh[7:4];
            units = curr_hh[3:0];
            wrap = 1'b0;
            // if current hour is 12, next hour is 1 and wrap=1
            if ((tens == 4'd1) && (units == 4'd2)) begin
                next_hh = 8'b00000001; // 0x01
                wrap = 1'b1;
            end else if (units == 4'd9) begin
                // units rollover, tens increment
                tens = tens + 1'b1;
                units = 4'd0;
                next_hh = {tens, units};
            end else begin
                units = units + 1'b1;
                next_hh = {tens, units};
            end
            bcd_hour_increment = {wrap, next_hh}; // MSB = wrap flag
        end
    endfunction

    // Declare variables for holding hour increment result outside always block
    reg [8:0] hour_next_and_wrap;

    always @(posedge clk) begin
        if (reset) begin
            // synchronous reset to 12:00:00 AM
            hh <= 8'b00010010; // 0x12 decimal 12
            mm <= 8'b00000000; // 00
            ss <= 8'b00000000; // 00
            pm <= 1'b0;        // AM = 0
        end else if (ena) begin
            // increment seconds
            if (ss == 8'b01011001) begin // 59 seconds BCD = 0x59
                ss <= 8'b00000000; // 00 seconds
                // increment minutes
                if (mm == 8'b01011001) begin // 59 minutes
                    mm <= 8'b00000000; // 00 minutes
                    // increment hour and toggle pm if hour wraps past 12
                    hour_next_and_wrap = bcd_hour_increment(hh);
                    hh <= hour_next_and_wrap[7:0];
                    if (hour_next_and_wrap[8]) begin
                        pm <= ~pm;
                    end
                end else begin
                    mm <= bcd_increment_59(mm);
                end
            end else begin
                ss <= bcd_increment_59(ss);
            end
        end
    end

endmodule