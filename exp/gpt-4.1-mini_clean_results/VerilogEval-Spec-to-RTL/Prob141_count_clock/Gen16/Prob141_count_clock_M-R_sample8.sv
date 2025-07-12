module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal binary counters for seconds and minutes (0-59)
reg [5:0] sec_bin;  // 6-bit to count 0-59
reg [5:0] min_bin;  // 6-bit to count 0-59

// Hour internal binary counter (1 to 12)
reg [3:0] hour_bin; 

// Function: Convert 6-bit binary (0-59) to BCD (8 bits)
function [7:0] bin_to_bcd_60(input [5:0] val);
    reg [3:0] tens;
    reg [3:0] units;
    begin
        tens  = val / 10;
        units = val % 10;
        bin_to_bcd_60 = {tens, units};
    end
endfunction

// Function: Convert binary hour (1..12) to BCD (8 bits)
function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
    begin
        if (bin_hour <= 4'd9)
            bin_to_bcd_hour = {4'd0, bin_hour}; // tens=0, units=bin_hour
        else
            bin_to_bcd_hour = {4'd1, bin_hour - 4'd10}; // tens=1, units=bin_hour-10
    end
endfunction

// Seconds counter
always @(posedge clk) begin
    if (reset) begin
        sec_bin <= 6'd0;
    end else if (ena) begin
        if (sec_bin == 6'd59)
            sec_bin <= 6'd0;
        else
            sec_bin <= sec_bin + 6'd1;
    end
end

// Minutes counter
always @(posedge clk) begin
    if (reset) begin
        min_bin <= 6'd0;
    end else if (ena && sec_bin == 6'd59) begin
        if (min_bin == 6'd59)
            min_bin <= 6'd0;
        else
            min_bin <= min_bin + 6'd1;
    end
end

// Hours and PM toggle
always @(posedge clk) begin
    if (reset) begin
        hour_bin <= 4'd12;
        pm       <= 1'b0; // AM
    end else if (ena && sec_bin == 6'd59 && min_bin == 6'd59) begin
        if (hour_bin == 4'd12)
            hour_bin <= 4'd1;
        else
            hour_bin <= hour_bin + 4'd1;

        // Toggle PM on 11->12 rollover
        if (hour_bin == 4'd11)
            pm <= ~pm;
    end
end

// Combinational output assignments
always @* begin
    ss = bin_to_bcd_60(sec_bin);
    mm = bin_to_bcd_60(min_bin);
    hh = bin_to_bcd_hour(hour_bin);
end

endmodule