module TopModule (
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Internal binary counters for seconds, minutes, hours
    reg [5:0] seconds; // 0 - 59
    reg [5:0] minutes; // 0 - 59
    reg [3:0] hours;   // 1 - 12

    // Helper signals for next state values
    wire seconds_max = (seconds == 6'd59);
    wire minutes_max = (minutes == 6'd59);
    wire hours_is_11 = (hours == 4'd11);
    wire hours_is_12 = (hours == 4'd12);

    // Synchronous logic: increment counters and toggle pm on hour rollover 11->12
    always @(posedge clk) begin
        if (reset) begin
            pm      <= 1'b0;     // AM
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;
        end else if (ena) begin
            if (seconds_max) begin
                seconds <= 6'd0;
                if (minutes_max) begin
                    minutes <= 6'd0;
                    if (hours_is_11) begin
                        hours <= 4'd12;
                        pm <= ~pm; // toggle PM at 11->12 transition
                    end else if (hours_is_12) begin
                        hours <= 4'd1;
                        // pm remains unchanged here
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

    // Combinational BCD conversion without multiplication:
    // multiply by 10 = digit * 8 + digit * 2

    // Function to convert 0-59 decimal to BCD (two digits)
    function [7:0] dec_to_bcd_0_59;
        input [5:0] val; // 0 to 59
        reg [3:0] tens;
        reg [3:0] units;
        reg [5:0] temp;
        begin
            // tens = val / 10 using subtraction-based division
            tens = 0;
            temp = val;
            while (temp >= 6'd10) begin
                temp = temp - 6'd10;
                tens = tens + 4'd1;
            end
            units = temp[3:0];
            dec_to_bcd_0_59 = {tens, units};
        end
    endfunction

    // Function to convert 1-12 decimal to BCD (two digits)
    function [7:0] dec_to_bcd_1_12;
        input [3:0] val; // 1 to 12
        reg [3:0] tens;
        reg [3:0] units;
        reg [3:0] temp;
        begin
            tens = 0;
            temp = val;
            if (temp >= 4'd10) begin
                tens = 4'd1;
                temp = temp - 4'd10;
            end
            units = temp[3:0];
            dec_to_bcd_1_12 = {tens, units};
        end
    endfunction

    // Assign combinational outputs from binary counters
    always @(*) begin
        ss = dec_to_bcd_0_59(seconds);
        mm = dec_to_bcd_0_59(minutes);
        hh = dec_to_bcd_1_12(hours);
    end

endmodule