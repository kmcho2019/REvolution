module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Internal binary counters for seconds and minutes (0..59)
    reg [5:0] seconds;
    reg [5:0] minutes;
    reg [3:0] hours;  // 1..12

    // Increment logic on clock edge
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
                    // Hour update and pm toggle on 11->12 rollover
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

    // Function: convert 0..59 decimal to BCD without multiplication (division by 10)
    function [7:0] dec_to_bcd_59;
        input [5:0] val;
        reg [3:0] tens;
        reg [3:0] units;
        reg [5:0] tmp;
        begin
            // Manual division by 10 without multiplication: subtract 10 repeatedly for tens digit
            tens = 4'd0;
            tmp = val;
            while (tmp >= 6'd10) begin
                tmp = tmp - 6'd10;
                tens = tens + 4'd1;
            end
            units = tmp[3:0];
            dec_to_bcd_59 = {tens, units};
        end
    endfunction

    // Function: convert hour binary 1..12 to BCD (like example 1)
    function [7:0] hour_to_bcd;
        input [3:0] h;
        reg [7:0] val;
        begin
            if (h <= 4'd9) val = {4'd0, h};
            else val = {4'd1, h - 4'd10};
            hour_to_bcd = val;
        end
    endfunction

    // Combinational output assignments
    always @(*) begin
        hh = hour_to_bcd(hours);
        mm = dec_to_bcd_59(minutes);
        ss = dec_to_bcd_59(seconds);
    end

endmodule