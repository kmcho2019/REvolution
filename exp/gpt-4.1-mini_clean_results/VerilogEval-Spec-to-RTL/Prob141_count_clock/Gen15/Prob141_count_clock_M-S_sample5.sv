module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Binary counters
    reg [5:0] seconds;  // 0-59
    reg [5:0] minutes;  // 0-59
    reg [3:0] hour;     // 1-12

    // Convert binary 0-59 to BCD (tens, units)
    function [7:0] bin_to_bcd60(input [5:0] val);
        reg [3:0] tens;
        reg [3:0] units;
        begin
            tens  = val / 6'd10;
            units = val % 6'd10;
            bin_to_bcd60 = {tens, units};
        end
    endfunction

    // Convert hour binary (1-12) to BCD
    function [7:0] bin_to_bcd_hour(input [3:0] val);
        reg [3:0] tens;
        reg [3:0] units;
        begin
            if (val >= 4'd10) begin
                tens = 4'd1;
                units = val - 4'd10;
            end else begin
                tens = 4'd0;
                units = val;
            end
            bin_to_bcd_hour = {tens, units};
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            seconds <= 6'd0;
            minutes <= 6'd0;
            hour    <= 4'd12;
            pm      <= 1'b0;
        end else if (ena) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    if (hour == 4'd12) begin
                        hour <= 4'd1;
                    end else begin
                        hour <= hour + 4'd1;
                    end
                    // Toggle pm when hour changes from 11 to 12
                    if (hour == 4'd11)
                        pm <= ~pm;
                end else begin
                    minutes <= minutes + 6'd1;
                end
            end else begin
                seconds <= seconds + 6'd1;
            end
        end
    end

    always @* begin
        hh = bin_to_bcd_hour(hour);
        mm = bin_to_bcd60(minutes);
        ss = bin_to_bcd60(seconds);
    end

endmodule