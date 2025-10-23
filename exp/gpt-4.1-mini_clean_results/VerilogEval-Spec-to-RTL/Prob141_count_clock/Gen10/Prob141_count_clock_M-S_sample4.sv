module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    reg [5:0] seconds; // 0 to 59
    reg [5:0] minutes; // 0 to 59
    reg [3:0] hours;   // 1 to 12

    // Increment time counters on ena with synchronous reset
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
                        pm <= ~pm;  // Toggle PM at 11->12
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

    // Simple combinational BCD conversion by repeated subtraction (no multiplication)
    function [3:0] to_bcd_tens;
        input [5:0] val;
        begin
            if (val >= 50) to_bcd_tens = 4'd5;
            else if (val >= 40) to_bcd_tens = 4'd4;
            else if (val >= 30) to_bcd_tens = 4'd3;
            else if (val >= 20) to_bcd_tens = 4'd2;
            else if (val >= 10) to_bcd_tens = 4'd1;
            else               to_bcd_tens = 4'd0;
        end
    endfunction

    always @(*) begin
        // Seconds
        ss[7:4] = to_bcd_tens(seconds);
        ss[3:0] = seconds - ss[7:4]*10;

        // Minutes
        mm[7:4] = to_bcd_tens(minutes);
        mm[3:0] = minutes - mm[7:4]*10;

        // Hours (1-12)
        if (hours >= 10) hh[7:4] = 4'd1;
        else             hh[7:4] = 4'd0;
        hh[3:0] = hours - hh[7:4]*10;
    end

endmodule