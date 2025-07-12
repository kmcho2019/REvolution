module TopModule (
    input        clk,
    input        reset,
    input        ena,
    output reg   pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Increment two-digit BCD counter modulo 60 (00-59)
    function [7:0] bcd_increment_59;
        input [7:0] val;
        reg [3:0] tens, units;
        begin
            tens = val[7:4];
            units = val[3:0];
            if (units == 4'd9) begin
                units = 4'd0;
                if (tens == 4'd5)
                    tens = 4'd0;
                else
                    tens = tens + 1;
            end else begin
                units = units + 1;
            end
            bcd_increment_59 = {tens, units};
        end
    endfunction

    // Check if val == 59 in BCD
    function is_59;
        input [7:0] val;
        begin
            is_59 = (val == 8'h59);
        end
    endfunction

    // Hour increment for 12-hour BCD clock (01 to 12)
    // Returns {wrapped_flag, next_hour}
    function [8:0] hour_increment;
        input [7:0] val;
        reg [3:0] tens, units;
        reg       wrapped;
        reg [7:0] next_hh;
        begin
            tens = val[7:4];
            units = val[3:0];
            wrapped = 0;

            if (val == 8'h12) begin
                next_hh = 8'h01; // wrap to 01
                wrapped = 1;
            end else if (tens == 4'd0) begin
                if (units == 4'd9) begin
                    next_hh = 8'h10;
                end else begin
                    next_hh = {tens, units + 4'd1};
                end
            end else begin // tens == 1
                if (units == 4'd1) begin
                    next_hh = 8'h12;
                end else if (units == 4'd2) begin
                    // Should not happen in normal increment, but wrap defensively
                    next_hh = 8'h01;
                    wrapped = 1;
                end else begin
                    next_hh = {tens, units + 4'd1};
                end
            end

            hour_increment = {wrapped, next_hh};
        end
    endfunction

    // Intermediate signals for next state
    reg pm_next;
    reg [7:0] hh_next;
    reg [7:0] mm_next;
    reg [7:0] ss_next;

    reg hour_wrapped;

    always @(*) begin
        pm_next = pm;
        hh_next = hh;
        mm_next = mm;
        ss_next = ss;
        hour_wrapped = 1'b0;

        if (reset) begin
            // Synchronous reset sets time to 12:00:00 AM
            pm_next = 1'b0;
            hh_next = 8'h12;
            mm_next = 8'h00;
            ss_next = 8'h00;
        end else if (ena) begin
            // Increment logic
            if (is_59(ss)) begin
                ss_next = 8'h00;
                if (is_59(mm)) begin
                    mm_next = 8'h00;
                    // increment hours
                    {hour_wrapped, hh_next} = hour_increment(hh);
                    if (hour_wrapped)
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
        // synchronous reset has highest priority
        if (reset) begin
            pm <= 1'b0;
            hh <= 8'h12;
            mm <= 8'h00;
            ss <= 8'h00;
        end else begin
            pm <= pm_next;
            hh <= hh_next;
            mm <= mm_next;
            ss <= ss_next;
        end
    end

endmodule