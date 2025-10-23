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
                        pm <= ~pm; // Toggle PM at 11->12
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

    // Simple combinational BCD conversion by subtraction without division/modulo
    function [7:0] to_bcd8(input [5:0] val);
        reg [3:0] tens;
        reg [3:0] units;
    begin
        if (val >= 6'd50) begin tens = 4'd5; units = val - 6'd50; end
        else if (val >= 6'd40) begin tens = 4'd4; units = val - 6'd40; end
        else if (val >= 6'd30) begin tens = 4'd3; units = val - 6'd30; end
        else if (val >= 6'd20) begin tens = 4'd2; units = val - 6'd20; end
        else if (val >= 6'd10) begin tens = 4'd1; units = val - 6'd10; end
        else begin tens = 4'd0; units = val; end
        to_bcd8 = {tens, units};
    end
    endfunction

    // Hours BCD conversion (1-12)
    wire [3:0] hh_tens = (hours >= 10) ? 4'd1 : 4'd0;
    wire [3:0] hh_units = (hours >= 10) ? (hours - 4'd10) : hours;

    always @(*) begin
        hh = {hh_tens, hh_units};
        mm = to_bcd8(minutes);
        ss = to_bcd8(seconds);
    end

endmodule