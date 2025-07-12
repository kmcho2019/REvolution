module TopModule (
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Internal binary counters for seconds and minutes (0-59)
    reg [5:0] seconds;
    reg [5:0] minutes;
    // Hour counter binary 1..12
    reg [3:0] hours;

    // Carry signals for increments
    wire seconds_rollover;
    wire minutes_rollover;

    // Seconds rollover when seconds = 59 and incremented
    assign seconds_rollover = (seconds == 6'd59) && ena;

    // Minutes rollover when minutes = 59 and incremented
    assign minutes_rollover = (minutes == 6'd59) && seconds_rollover;

    // Sequential counters with synchronous reset and enable
    always @(posedge clk) begin
        if (reset) begin
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;
            pm      <= 1'b0; // AM
        end else if (ena) begin
            // Increment seconds or rollover
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                // Increment minutes or rollover
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    // Increment hour with 12-hour wrap and pm toggle
                    if (hours == 4'd11) begin
                        hours <= 4'd12;
                        pm <= ~pm;
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

    // Function to compute BCD tens digit for 0-59 value using subtraction (no multiplication)
    function [3:0] bcd_tens_0_59(input [5:0] val);
        begin
            if (val >= 50)       bcd_tens_0_59 = 4'd5;
            else if (val >= 40)  bcd_tens_0_59 = 4'd4;
            else if (val >= 30)  bcd_tens_0_59 = 4'd3;
            else if (val >= 20)  bcd_tens_0_59 = 4'd2;
            else if (val >= 10)  bcd_tens_0_59 = 4'd1;
            else                 bcd_tens_0_59 = 4'd0;
        end
    endfunction

    // Compute units digit by val - tens*10 (using shift and add for tens*10)
    function [3:0] bcd_units_0_59(input [5:0] val, input [3:0] tens);
        reg [6:0] tens_times_10;
        begin
            // tens*10 = tens*8 + tens*2 = (tens << 3) + (tens << 1)
            tens_times_10 = (tens << 3) + (tens << 1);
            bcd_units_0_59 = val - tens_times_10[5:0];
        end
    endfunction

    // Function to convert hour (1-12) to BCD (tens and units)
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

    // Registered outputs to break combinational path and improve timing
    reg [7:0] ss_bcd_reg;
    reg [7:0] mm_bcd_reg;
    reg [7:0] hh_bcd_reg;

    always @(posedge clk) begin
        if (reset) begin
            ss_bcd_reg <= 8'd0;
            mm_bcd_reg <= 8'd0;
            hh_bcd_reg <= 8'd0;
        end else begin
            // Convert seconds to BCD
            reg [3:0] s_tens, s_units;
            s_tens = bcd_tens_0_59(seconds);
            s_units = bcd_units_0_59(seconds, s_tens);
            ss_bcd_reg <= {s_tens, s_units};

            // Convert minutes to BCD
            reg [3:0] m_tens, m_units;
            m_tens = bcd_tens_0_59(minutes);
            m_units = bcd_units_0_59(minutes, m_tens);
            mm_bcd_reg <= {m_tens, m_units};

            // Convert hours to BCD
            hh_bcd_reg <= bin_to_bcd_hour(hours);
        end
    end

    // Assign registered outputs to module outputs
    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'd0;
            mm <= 8'd0;
            ss <= 8'd0;
        end else begin
            hh <= hh_bcd_reg;
            mm <= mm_bcd_reg;
            ss <= ss_bcd_reg;
        end
    end

endmodule