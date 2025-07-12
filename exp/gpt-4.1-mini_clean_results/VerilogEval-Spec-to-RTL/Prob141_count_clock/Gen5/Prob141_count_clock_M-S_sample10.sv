module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh, // BCD hours
    output reg [7:0]  mm, // BCD minutes
    output reg [7:0]  ss  // BCD seconds
);

    // Binary counters for seconds, minutes, hours
    reg [5:0] seconds;  // 0 to 59
    reg [5:0] minutes;  // 0 to 59
    reg [3:0] hours;    // 1 to 12

    // Increment logic
    always @(posedge clk) begin
        if (reset) begin
            pm      <= 1'b0;
            hours   <= 4'd12;
            minutes <= 6'd0;
            seconds <= 6'd0;
        end else if (ena) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    // Hour increment and pm toggle
                    if (hours == 4'd12) begin
                        hours <= 4'd1;
                        pm <= ~pm;
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

    // Binary to BCD conversion for seconds and minutes (0-59)
    // tens = value / 10, units = value % 10
    function [3:0] bcd_tens(input [5:0] val);
        bcd_tens = val / 6'd10;
    endfunction

    function [3:0] bcd_units(input [5:0] val);
        bcd_units = val % 6'd10;
    endfunction

    // Binary to BCD for hours (1-12)
    // tens = hours / 10, units = hours % 10
    function [3:0] bcd_tens_h(input [3:0] val);
        bcd_tens_h = val / 4'd10;
    endfunction

    function [3:0] bcd_units_h(input [3:0] val);
        bcd_units_h = val % 4'd10;
    endfunction

    always @(*) begin
        hh = {bcd_tens_h(hours), bcd_units_h(hours)};
        mm = {bcd_tens(minutes), bcd_units(minutes)};
        ss = {bcd_tens(seconds), bcd_units(seconds)};
    end

endmodule