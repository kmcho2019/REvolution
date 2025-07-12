module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hours_tens;  // Tens place of hours
reg [3:0] hours_ones;  // Ones place of hours
reg [5:0] minutes;     // Minutes
reg [5:0] seconds;     // Seconds
reg pm_flag;

always @(posedge clk) begin
    if (reset) begin
        hours_tens <= 4'b0001;  // Reset hours to 1 (tens place)
        hours_ones <= 4'b0001;  // Reset hours to 1 (ones place)
        minutes <= 6'b000000;   // Reset minutes to 00
        seconds <= 6'b000000;   // Reset seconds to 00
        pm_flag <= 1'b0;        // Reset pm_flag to 0 (AM)
    end else if (ena) begin
        if (seconds == 6'b001001) begin  // Check for 59 in BCD
            seconds <= 6'b000000;          // Reset seconds to 00
            if (minutes == 6'b001001) begin  // Check for 59 in BCD
                minutes <= 6'b000000;        // Reset minutes to 00
                if ((hours_tens == 4'b0001 && hours_ones == 4'b1000) || (hours_tens == 4'b0010 && hours_ones == 4'b0000)) begin
                    hours_tens <= 4'b0001;  // Reset hours to 1 (tens place)
                    hours_ones <= 4'b0001;  // Reset hours to 1 (ones place)
                    pm_flag <= ~pm_flag;     // Toggle pm_flag
                end else if (hours_tens == 4'b0010 && hours_ones == 4'b1000) begin
                    hours_tens <= 4'b0001;  // Reset hours to 1 (tens place)
                    hours_ones <= 4'b0001;  // Reset hours to 1 (ones place)
                end else begin
                    if (hours_ones == 4'b1001) begin  // 9 in BCD
                        hours_tens <= hours_tens + 1;
                        hours_ones <= 4'b0000;
                    end else begin
                        hours_ones <= hours_ones + 1;
                    end
                end
            end else begin
                if (minutes == 6'b000011) begin
                    minutes <= 6'b000100;
                end else if (minutes == 6'b001011) begin
                    minutes <= 6'b010000;
                end else begin
                    minutes <= minutes + 1;
                end
            end
        end else begin
            if (seconds == 6'b000011) begin
                seconds <= 6'b000100;
            end else if (seconds == 6'b001011) begin
                seconds <= 6'b010000;
            end else begin
                seconds <= seconds + 1;
            end
        end
    end
end

assign hh = {4'b0000, hours_tens, hours_ones};  // Corrected BCD encoding for hours
assign mm = {2'b00, minutes};                  // Corrected BCD encoding for minutes
assign ss = {2'b00, seconds};                  // Corrected BCD encoding for seconds
assign pm = pm_flag;

endmodule