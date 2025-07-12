module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

    // Binary counters for seconds and minutes (0..59)
    reg [5:0] seconds;  
    reg [5:0] minutes;
    
    // Binary counter for hours (1..12)
    reg [3:0] hour_bin;

    // Increment logic with synchronous reset and enable
    always @(posedge clk) begin
        if (reset) begin
            pm       <= 1'b0;   // AM
            hour_bin <= 4'd12;
            minutes  <= 6'd0;
            seconds  <= 6'd0;
        end else if (ena) begin
            // Increment seconds
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                // Increment minutes
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    // Increment hour
                    if (hour_bin == 4'd12) begin
                        hour_bin <= 4'd1;
                    end else begin
                        hour_bin <= hour_bin + 4'd1;
                    end
                    // Toggle PM on 11 -> 12
                    if (hour_bin == 4'd11)
                        pm <= ~pm;
                end else begin
                    minutes <= minutes + 6'd1;
                end
            end else begin
                seconds <= seconds + 6'd1;
            end
        end
    end

    // Function: Convert 0-59 binary to BCD (tens, units)
    function [7:0] bin_to_bcd_2digit(input [5:0] val);
        reg [3:0] tens;
        reg [3:0] units;
        begin
            tens  = val / 10;
            units = val % 10;
            bin_to_bcd_2digit = {tens, units};
        end
    endfunction

    // Function: Convert binary hour 1-12 to BCD
    function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
        begin
            if (bin_hour <= 4'd9)
                bin_to_bcd_hour = {4'd0, bin_hour};
            else
                bin_to_bcd_hour = {4'd1, bin_hour - 4'd10};
        end
    endfunction

    // Combinational output assignments
    assign ss = bin_to_bcd_2digit(seconds);
    assign mm = bin_to_bcd_2digit(minutes);
    assign hh = bin_to_bcd_hour(hour_bin);

endmodule