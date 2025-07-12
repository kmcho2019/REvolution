module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Internal binary counters
    reg [5:0] seconds; // 0 to 59
    reg [5:0] minutes; // 0 to 59
    reg [3:0] hours;   // 1 to 12

    // Temporary BCD conversion variables (combinational)
    reg [3:0] sec_tens, sec_units;
    reg [3:0] min_tens, min_units;
    reg [3:0] hour_tens, hour_units;

    // Convert binary 0-59 to BCD tens digit (combinational)
    function [3:0] bcd_tens_60;
        input [5:0] val;
        begin
            if      (val >= 50) bcd_tens_60 = 4'd5;
            else if (val >= 40) bcd_tens_60 = 4'd4;
            else if (val >= 30) bcd_tens_60 = 4'd3;
            else if (val >= 20) bcd_tens_60 = 4'd2;
            else if (val >= 10) bcd_tens_60 = 4'd1;
            else                bcd_tens_60 = 4'd0;
        end
    endfunction

    // Convert binary 0-59 to BCD units digit via subtraction (combinational)
    // units = val - tens*10, tens*10 computed with shift and add (tens*8 + tens*2)
    function [3:0] bcd_units_60;
        input [5:0] val;
        input [3:0] tens;
        reg [6:0] tens_mul_10;
        begin
            tens_mul_10 = (tens << 3) + (tens << 1); // tens*8 + tens*2 = tens*10
            bcd_units_60 = val - tens_mul_10;
        end
    endfunction

    // Convert binary hour (1-12) to BCD
    function [7:0] bin_to_bcd_hour;
        input [3:0] bin_hour;
        reg [3:0] tens_digit;
        reg [3:0] units_digit;
        begin
            if (bin_hour >= 10) begin
                tens_digit  = 4'd1;
                units_digit = bin_hour - 4'd10;
            end else begin
                tens_digit  = 4'd0;
                units_digit = bin_hour;
            end
            bin_to_bcd_hour = {tens_digit, units_digit};
        end
    endfunction

    // Sequential counting logic with synchronous reset and enable
    always @(posedge clk) begin
        if (reset) begin
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12; // Start at 12:00:00 AM
            pm      <= 1'b0;  // AM
        end else if (ena) begin
            // Increment seconds and handle rollover
            if (seconds == 6'd59) begin
                seconds <= 6'd0;

                // Increment minutes and handle rollover
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;

                    // Increment hours and handle 12-hour wrap and pm toggle
                    if (hours == 4'd11) begin
                        hours <= 4'd12;
                        pm <= ~pm; // toggle pm at 11 -> 12
                    end else if (hours == 4'd12) begin
                        hours <= 4'd1;
                    end else begin
                        hours <= hours + 4'd1;
                    end

                end else begin
                    minutes <= minutes + 6'd1;
                end

            end else begin
                seconds <= seconds + 6'd1;
            end
        end
    end

    // Combinational BCD conversion for outputs (to minimize clock-to-output delay, register outputs)
    always @(*) begin
        // Seconds BCD conversion
        sec_tens  = bcd_tens_60(seconds);
        sec_units = bcd_units_60(seconds, sec_tens);

        // Minutes BCD conversion
        min_tens  = bcd_tens_60(minutes);
        min_units = bcd_units_60(minutes, min_tens);

        // Hours BCD conversion
        {hour_tens, hour_units} = bin_to_bcd_hour(hours);

        // Assign to outputs (will be registered on next clk)
        ss = {sec_tens, sec_units};
        mm = {min_tens, min_units};
        hh = {hour_tens, hour_units};
    end

endmodule