module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    reg [5:0] seconds; // 0-59
    reg [5:0] minutes; // 0-59
    reg [3:0] hours;   // 1-12

    // Internal BCD registers updated synchronously to reduce toggling and simplify logic
    reg [7:0] bcd_ss;
    reg [7:0] bcd_mm;
    reg [7:0] bcd_hh;

    // Convert binary value (0-59) to BCD (tens*10 + units)
    // Avoid multiplication by 10, use shifts and addition: tens*10 = (tens<<3)+(tens<<1)
    function [3:0] bcd_tens_0to59;
        input [5:0] val;
        begin
            if (val >= 6'd50) bcd_tens_0to59 = 4'd5;
            else if (val >= 6'd40) bcd_tens_0to59 = 4'd4;
            else if (val >= 6'd30) bcd_tens_0to59 = 4'd3;
            else if (val >= 6'd20) bcd_tens_0to59 = 4'd2;
            else if (val >= 6'd10) bcd_tens_0to59 = 4'd1;
            else bcd_tens_0to59 = 4'd0;
        end
    endfunction

    // Convert binary value (1-12) to BCD hours
    // tens = 1 if >=10 else 0; units = val - tens*10 = val - ((tens<<3)+(tens<<1))
    function [3:0] bcd_tens_1to12;
        input [3:0] val;
        begin
            bcd_tens_1to12 = (val >= 4'd10) ? 4'd1 : 4'd0;
        end
    endfunction

    // Compute units digit for 0-59 using tens digit without multiplication
    function [3:0] bcd_units_0to59;
        input [5:0] val;
        input [3:0] tens;
        begin
            // units = val - tens*10 = val - (tens<<3) - (tens<<1)
            bcd_units_0to59 = val - ( (tens << 3) + (tens << 1) );
        end
    endfunction

    // Compute units digit for 1-12 similarly
    function [3:0] bcd_units_1to12;
        input [3:0] val;
        input [3:0] tens;
        begin
            bcd_units_1to12 = val - ( (tens << 3) + (tens << 1) );
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            pm      <= 1'b0;
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;

            // Update BCD outputs on reset
            // seconds
            bcd_ss[7:4] <= bcd_tens_0to59(6'd0);
            bcd_ss[3:0] <= bcd_units_0to59(6'd0, bcd_tens_0to59(6'd0));
            // minutes
            bcd_mm[7:4] <= bcd_tens_0to59(6'd0);
            bcd_mm[3:0] <= bcd_units_0to59(6'd0, bcd_tens_0to59(6'd0));
            // hours
            bcd_hh[7:4] <= bcd_tens_1to12(4'd12);
            bcd_hh[3:0] <= bcd_units_1to12(4'd12, bcd_tens_1to12(4'd12));
        end else if (ena) begin
            // Increment seconds
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                // Increment minutes
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    // Increment hours
                    if (hours == 4'd11) begin
                        hours <= 4'd12;
                        pm <= ~pm; // Toggle AM/PM at 11->12
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

            // Update BCD outputs after incrementing counters
            bcd_ss[7:4] <= bcd_tens_0to59(seconds);
            bcd_ss[3:0] <= bcd_units_0to59(seconds, bcd_tens_0to59(seconds));
            bcd_mm[7:4] <= bcd_tens_0to59(minutes);
            bcd_mm[3:0] <= bcd_units_0to59(minutes, bcd_tens_0to59(minutes));
            bcd_hh[7:4] <= bcd_tens_1to12(hours);
            bcd_hh[3:0] <= bcd_units_1to12(hours, bcd_tens_1to12(hours));
        end
        // If not ena and not reset, maintain current counters and BCD outputs (no change)
    end

    // Output assignment
    always @(posedge clk) begin
        // Outputs registered to reduce glitches
        pm <= pm;
        hh <= bcd_hh;
        mm <= bcd_mm;
        ss <= bcd_ss;
    end

endmodule