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
reg [5:0] sec;   // 0..59
reg [5:0] min;   // 0..59
reg [3:0] hour;  // 1..12

// Convert binary number (0-59) to two BCD digits
function [7:0] bin_to_bcd60(input [5:0] val);
    reg [3:0] tens;
    reg [3:0] units;
    begin
        tens  = val / 10;
        units = val % 10;
        bin_to_bcd60 = {tens, units};
    end
endfunction

// Convert binary hour (1..12) to two BCD digits
function [7:0] bin_to_bcd_hour(input [3:0] val);
    reg [3:0] tens;
    reg [3:0] units;
    begin
        tens  = (val >= 10) ? 4'd1 : 4'd0;
        units = (val >= 10) ? val - 4'd10 : val;
        bin_to_bcd_hour = {tens, units};
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        sec  <= 6'd0;
        min  <= 6'd0;
        hour <= 4'd12;
        pm   <= 1'b0; // AM
    end else if (ena) begin
        if (sec == 6'd59) begin
            sec <= 6'd0;
            if (min == 6'd59) begin
                min <= 6'd0;
                if (hour == 4'd12) begin
                    hour <= 4'd1;
                    pm   <= ~pm; // Toggle pm when hour wraps 12->1
                end else begin
                    hour <= hour + 4'd1;
                end
            end else begin
                min <= min + 6'd1;
            end
        end else begin
            sec <= sec + 6'd1;
        end
    end
end

always @* begin
    hh = bin_to_bcd_hour(hour);
    mm = bin_to_bcd60(min);
    ss = bin_to_bcd60(sec);
end

endmodule