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
    reg [5:0] seconds; // 0-59
    reg [5:0] minutes; // 0-59
    reg [3:0] hours;   // 1-12

    // BCD registers to hold outputs (registered to reduce glitches)
    reg [7:0] bcd_seconds;
    reg [7:0] bcd_minutes;
    reg [7:0] bcd_hours;

    // Increment counters on ena, with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            pm      <= 1'b0;     // AM
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;    // 12 o'clock
        end else if (ena) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    // Hour counting with pm toggle at 11->12 transition
                    if (hours == 4'd11) begin
                        hours <= 4'd12;
                        pm <= ~pm;
                    end else if (hours == 4'd12) begin
                        hours <= 4'd1;
                    end else begin
                        hours <= hours + 1;
                    end
                end else begin
                    minutes <= minutes + 1;
                end
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    // Efficient combinational conversion of 0-59 binary to BCD (tens and units)
    function [3:0] bcd_tens(input [5:0] val);
        begin
            if (val >= 50) bcd_tens = 4'd5;
            else if (val >= 40) bcd_tens = 4'd4;
            else if (val >= 30) bcd_tens = 4'd3;
            else if (val >= 20) bcd_tens = 4'd2;
            else if (val >= 10) bcd_tens = 4'd1;
            else bcd_tens = 4'd0;
        end
    endfunction

    function [3:0] bcd_units(input [5:0] val, input [3:0] tens);
        reg [7:0] tens_mul_10;
        begin
            // tens*10 = tens*8 + tens*2 using shifts
            tens_mul_10 = (tens << 3) + (tens << 1);
            bcd_units = val - tens_mul_10;
        end
    endfunction

    // Hour conversion: binary (1-12) to BCD with simple logic
    function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
        reg [3:0] tens_digit;
        reg [3:0] units_digit;
        begin
            if (bin_hour >= 10) begin
                tens_digit = 4'd1;
                units_digit = bin_hour - 4'd10;
            end else begin
                tens_digit = 4'd0;
                units_digit = bin_hour;
            end
            bin_to_bcd_hour = {tens_digit, units_digit};
        end
    endfunction

    // Register outputs on clk to reduce glitches and timing path length
    always @(posedge clk) begin
        if (reset) begin
            bcd_seconds <= 8'd0;
            bcd_minutes <= 8'd0;
            bcd_hours   <= 8'h12; // 12 in BCD: 0x12
        end else begin
            bcd_seconds[7:4] <= bcd_tens(seconds);
            bcd_seconds[3:0] <= bcd_units(seconds, bcd_seconds[7:4]);

            bcd_minutes[7:4] <= bcd_tens(minutes);
            bcd_minutes[3:0] <= bcd_units(minutes, bcd_minutes[7:4]);

            bcd_hours <= bin_to_bcd_hour(hours);
        end
    end

    // Output assignments from registered BCD values
    always @(*) begin
        ss = bcd_seconds;
        mm = bcd_minutes;
        hh = bcd_hours;
    end

endmodule