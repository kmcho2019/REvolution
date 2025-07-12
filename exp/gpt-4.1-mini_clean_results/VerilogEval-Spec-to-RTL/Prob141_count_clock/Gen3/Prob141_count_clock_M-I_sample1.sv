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
    // Output: {wrap_flag, next_hour_bcd}
    function [8:0] bcd_hour_increment(input [7:0] curr_hh);
        reg [3:0] tens;
        reg [3:0] units;
        reg wrap;
        reg [7:0] next_hh;
        begin
            tens = curr_hh[7:4];
            units = curr_hh[3:0];
            wrap = 1'b0;
            if ((tens == 4'd1) && (units == 4'd2)) begin
                // Wrap from 12 to 1
                next_hh = 8'b00000001; // 0x01
                wrap = 1'b1;
            end else if (units == 4'd9) begin
                units = 4'd0;
                tens = tens + 1'b1;
                next_hh = {tens, units};
            end else begin
                units = units + 1'b1;
                next_hh = {tens, units};
            end
            bcd_hour_increment = {wrap, next_hh};
        end
    endfunction

    // Registers for next state calculation
    reg [7:0] ss_next;
    reg [7:0] mm_next;
    reg [7:0] hh_next;
    reg pm_next;
    reg wrap_hour;

    always @* begin
        // Default next state = current state
        ss_next = ss;
        mm_next = mm;
        hh_next = hh;
        pm_next = pm;
        wrap_hour = 1'b0;

        if (ena) begin
            if (ss == 8'h59) begin
                ss_next = 8'h00;
                if (mm == 8'h59) begin
                    mm_next = 8'h00;
                    // Hour increment with wrap detection
                    {wrap_hour, hh_next} = bcd_hour_increment(hh);
                    if (wrap_hour)
                        pm_next = ~pm;
                end else begin
                    mm_next = bcd_increment_59(mm);
                end
            end else begin
                ss_next = bcd_increment_59(ss);
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'h12;    // 12 decimal in BCD
            mm <= 8'h00;
            ss <= 8'h00;
            pm <= 1'b0;     // AM
        end else begin
            hh <= hh_next;
            mm <= mm_next;
            ss <= ss_next;
            pm <= pm_next;
        end
    end

endmodule