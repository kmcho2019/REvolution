module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Internal representation of hour (1 to 12)
    reg [3:0] hour_bin; // 4-bit binary hour (1-12)
    reg [3:0] min_tens, min_ones;
    reg [3:0] sec_tens, sec_ones;

    // Convert binary hour (1-12) to BCD (2 digits)
    function [7:0] bin_to_bcd_hour;
        input [3:0] hour;
        begin
            // hour is 1 to 12
            if (hour < 10)
                bin_to_bcd_hour = {4'd0, hour}; // 0X
            else
                bin_to_bcd_hour = {4'd1, hour - 4'd10}; // 1X
        end
    endfunction

    // Increment BCD digit with decimal limit
    function [3:0] bcd_inc_digit;
        input [3:0] digit;
        input [3:0] limit;
        begin
            if (digit == limit)
                bcd_inc_digit = 4'd0;
            else
                bcd_inc_digit = digit + 4'd1;
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;             // AM
            hour_bin <= 4'd12;      // 12
            min_tens <= 4'd0;
            min_ones <= 4'd0;
            sec_tens <= 4'd0;
            sec_ones <= 4'd0;
        end else if (ena) begin
            // Increment seconds
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                if (sec_tens == 4'd5) begin
                    sec_tens <= 4'd0;
                    // Seconds rolled over, increment minutes
                    if (min_ones == 4'd9) begin
                        min_ones <= 4'd0;
                        if (min_tens == 4'd5) begin
                            min_tens <= 4'd0;
                            // Minutes rolled over, increment hour
                            if (hour_bin == 4'd11) begin
                                hour_bin <= 4'd12;
                                pm <= ~pm;  // Toggle PM at 11->12 transition
                            end else if (hour_bin == 4'd12) begin
                                hour_bin <= 4'd1;
                            end else begin
                                hour_bin <= hour_bin + 4'd1;
                            end
                        end else begin
                            min_tens <= min_tens + 4'd1;
                        end
                    end else begin
                        min_ones <= min_ones + 4'd1;
                    end
                end else begin
                    sec_tens <= sec_tens + 4'd1;
                end
            end else begin
                sec_ones <= sec_ones + 4'd1;
            end
        end
    end

    // Continuous output assignment of BCD hour, minute, second
    always @(*) begin
        hh = bin_to_bcd_hour(hour_bin);
        mm = {min_tens, min_ones};
        ss = {sec_tens, sec_ones};
    end

endmodule