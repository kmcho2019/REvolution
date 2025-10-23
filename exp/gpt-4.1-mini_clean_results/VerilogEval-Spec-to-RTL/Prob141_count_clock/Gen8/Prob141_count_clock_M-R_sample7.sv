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

    // Counting logic: synchronous with reset and enable
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
                    // Hour increment logic with case for clarity
                    case (hours)
                        4'd11: begin
                            hours <= 4'd12;
                            pm <= ~pm;  // Toggle PM at 11->12
                        end
                        4'd12: hours <= 4'd1;
                        default: hours <= hours + 1;
                    endcase
                end else begin
                    minutes <= minutes + 1;
                end
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    // Function to convert 0-59 into BCD (two digits)
    function [7:0] bin_to_bcd_60;
        input [5:0] val;
        reg [3:0] tens;
        reg [3:0] units;
        integer temp;
    begin
        temp = val;
        tens = 0;
        while (temp >= 10) begin
            temp = temp - 10;
            tens = tens + 1;
        end
        units = temp[3:0];
        bin_to_bcd_60 = {tens, units};
    end
    endfunction

    // Function to convert 1-12 into BCD (two digits)
    function [7:0] bin_to_bcd_12;
        input [3:0] val;
        reg [3:0] tens;
        reg [3:0] units;
    begin
        if (val >= 10)
            tens = 4'd1;
        else
            tens = 4'd0;
        units = val - (tens * 4'd10);
        bin_to_bcd_12 = {tens, units};
    end
    endfunction

    // Update BCD outputs synchronously when counts change (same clock)
    always @(posedge clk) begin
        // Update seconds BCD
        ss <= bin_to_bcd_60(seconds);
        // Update minutes BCD
        mm <= bin_to_bcd_60(minutes);
        // Update hours BCD
        hh <= bin_to_bcd_12(hours);
    end

endmodule