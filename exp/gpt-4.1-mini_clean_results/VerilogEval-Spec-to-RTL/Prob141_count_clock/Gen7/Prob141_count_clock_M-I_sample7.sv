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

    // Synchronous counters and pm toggle
    always @(posedge clk) begin
        if (reset) begin
            pm      <= 1'b0;
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;
        end else if (ena) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
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

    // Combinational divider by 10 function for values up to 59 or 12
    // Returns {tens_digit, units_digit}
    function [7:0] div10_bcd;
        input [5:0] val; // input can be up to 59
        reg [3:0] tens;
        reg [3:0] units;
        begin
            if (val >= 50) begin
                tens = 4'd5; units = val - 6'd50;
            end else if (val >= 40) begin
                tens = 4'd4; units = val - 6'd40;
            end else if (val >= 30) begin
                tens = 4'd3; units = val - 6'd30;
            end else if (val >= 20) begin
                tens = 4'd2; units = val - 6'd20;
            end else if (val >= 10) begin
                tens = 4'd1; units = val - 6'd10;
            end else begin
                tens = 4'd0; units = val;
            end
            div10_bcd = {tens, units};
        end
    endfunction

    // Combinational divider for hours (1-12)
    function [7:0] div10_bcd_hour;
        input [3:0] val; // up to 12
        reg [3:0] tens;
        reg [3:0] units;
        begin
            if (val >= 10) begin
                tens = 4'd1;
                units = val - 4'd10;
            end else begin
                tens = 4'd0;
                units = val;
            end
            div10_bcd_hour = {tens, units};
        end
    endfunction

    // Registered outputs updated only on reset or enable edge
    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'h12; // 12 -> 0x12 BCD
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            ss <= div10_bcd(seconds);
            mm <= div10_bcd(minutes);
            hh <= div10_bcd_hour(hours);
        end
    end

endmodule