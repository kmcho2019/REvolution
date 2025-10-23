module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

// Internal binary counters
reg [5:0] seconds; // 0-59
reg [5:0] minutes; // 0-59
reg [3:0] hours;   // 1-12

always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours   <= 4'd12;
        pm      <= 1'b0; // AM
    end else if (ena) begin
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 4'd11) begin
                    hours <= 4'd12;
                    pm <= ~pm; // Toggle PM at 11->12
                end else if (hours == 4'd12) begin
                    hours <= 4'd1;
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

// Convert binary 0-59 to BCD (two digits) without division/modulo
function [7:0] bin_to_bcd_0_59;
    input [5:0] val;
    reg [3:0] tens;
    reg [3:0] units;
begin
    if (val >= 6'd50) begin
        tens = 4'd5; units = val - 6'd50;
    end else if (val >= 6'd40) begin
        tens = 4'd4; units = val - 6'd40;
    end else if (val >= 6'd30) begin
        tens = 4'd3; units = val - 6'd30;
    end else if (val >= 6'd20) begin
        tens = 4'd2; units = val - 6'd20;
    end else if (val >= 6'd10) begin
        tens = 4'd1; units = val - 6'd10;
    end else begin
        tens = 4'd0; units = val;
    end
    bin_to_bcd_0_59 = {tens, units[3:0]};
end
endfunction

// Convert hours (1-12) to BCD (two digits)
function [7:0] bin_to_bcd_1_12;
    input [3:0] val;
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
    bin_to_bcd_1_12 = {tens, units};
end
endfunction

assign ss = bin_to_bcd_0_59(seconds);
assign mm = bin_to_bcd_0_59(minutes);
assign hh = bin_to_bcd_1_12(hours);

endmodule