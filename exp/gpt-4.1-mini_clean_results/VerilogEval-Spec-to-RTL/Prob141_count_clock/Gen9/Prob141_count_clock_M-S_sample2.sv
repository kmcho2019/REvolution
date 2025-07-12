module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Internal binary counters
    reg [3:0] hour_bin;      // 1 to 12
    reg [5:0] minute_bin;    // 0 to 59
    reg [5:0] second_bin;    // 0 to 59

    // Convert binary (0-59) to BCD (two digits)
    function [7:0] bin_to_bcd_60;
        input [5:0] val;
        reg [3:0] tens;
        reg [3:0] ones;
        begin
            tens = val / 6'd10;
            ones = val % 6'd10;
            bin_to_bcd_60 = {tens, ones};
        end
    endfunction

    // Convert binary hour (1-12) to BCD
    function [7:0] bin_to_bcd_hour;
        input [3:0] hour;
        begin
            if (hour < 10)
                bin_to_bcd_hour = {4'd0, hour};
            else
                bin_to_bcd_hour = {4'd1, hour - 4'd10};
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;          // AM
            hour_bin <= 4'd12;   // 12
            minute_bin <= 6'd0;
            second_bin <= 6'd0;
        end else if (ena) begin
            if (second_bin == 6'd59) begin
                second_bin <= 6'd0;
                if (minute_bin == 6'd59) begin
                    minute_bin <= 6'd0;
                    if (hour_bin == 4'd11) begin
                        hour_bin <= 4'd12;
                        pm <= ~pm; // toggle PM at 11->12
                    end else if (hour_bin == 4'd12) begin
                        hour_bin <= 4'd1;
                    end else begin
                        hour_bin <= hour_bin + 4'd1;
                    end
                end else begin
                    minute_bin <= minute_bin + 6'd1;
                end
            end else begin
                second_bin <= second_bin + 6'd1;
            end
        end
    end

    always @(*) begin
        hh = bin_to_bcd_hour(hour_bin);
        mm = bin_to_bcd_60(minute_bin);
        ss = bin_to_bcd_60(second_bin);
    end

endmodule