module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

reg [5:0] seconds; // 0-59
reg [5:0] minutes; // 0-59
reg [3:0] hours;   // 1-12 (binary)

// Increment seconds on ena
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
                    pm <= ~pm; // toggle pm at 11->12
                end else if (hours == 4'd12) begin
                    hours <= 4'd1;
                    // pm unchanged
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

// Function to convert a 2-digit binary number (0-59) to BCD
function [7:0] bin2bcd_60;
    input [5:0] bin;
    reg [3:0] tens;
    reg [3:0] units;
    begin
        tens = bin / 10;
        units = bin % 10;
        bin2bcd_60 = {tens, units};
    end
endfunction

// Function to convert hour (1-12) binary to BCD
function [7:0] bin2bcd_hour;
    input [3:0] hour_bin;
    reg [3:0] tens;
    reg [3:0] units;
    begin
        if (hour_bin == 4'd12) begin
            tens = 4'd1;
            units = 4'd2;
        end else if (hour_bin >= 4'd10) begin
            tens = 4'd1;
            units = hour_bin - 4'd10;
        end else begin
            tens = 4'd0;
            units = hour_bin;
        end
        bin2bcd_hour = {tens, units};
    end
endfunction

always @(*) begin
    hh = bin2bcd_hour(hours);
    mm = bin2bcd_60(minutes);
    ss = bin2bcd_60(seconds);
end

endmodule