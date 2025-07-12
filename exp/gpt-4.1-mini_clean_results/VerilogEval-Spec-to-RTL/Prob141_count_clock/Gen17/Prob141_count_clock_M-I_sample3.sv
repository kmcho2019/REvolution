module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Binary counters for seconds and minutes (0..59)
    reg [5:0] seconds;
    reg [5:0] minutes;
    // Binary hour counter (1..12)
    reg [3:0] hour_bin;

    // Function: Convert 0..59 binary to BCD {tens, units}
    function [7:0] bin_to_bcd_60(input [5:0] bin60);
        reg [3:0] tens;
        reg [3:0] units;
        begin
            tens  = bin60 / 6'd10;
            units = bin60 % 6'd10;
            bin_to_bcd_60 = {tens, units};
        end
    endfunction

    // Function: Convert binary hour (1..12) to BCD
    function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
        begin
            if (bin_hour <= 4'd9)
                bin_to_bcd_hour = {4'd0, bin_hour};          // tens=0
            else
                bin_to_bcd_hour = {4'd1, bin_hour - 4'd10}; // tens=1
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            pm       <= 1'b0;
            hour_bin <= 4'd12;
            minutes  <= 6'd0;
            seconds  <= 6'd0;
        end else if (ena) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    // Hour increment (1..12)
                    if (hour_bin == 4'd12)
                        hour_bin <= 4'd1;
                    else
                        hour_bin <= hour_bin + 4'd1;
                    // Toggle pm when hour rolls from 11 to 12
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

    // Combinational output assignments
    always @* begin
        hh = bin_to_bcd_hour(hour_bin);
        mm = bin_to_bcd_60(minutes);
        ss = bin_to_bcd_60(seconds);
    end

endmodule