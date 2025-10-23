module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

reg [6:0] sec_bin;   // 0-59 for seconds
reg [6:0] min_bin;   // 0-59 for minutes
reg [3:0] hour_bin;  // 1-12 for hours

// Function to convert 0-59 binary to BCD (two digits)
function [7:0] bin_to_bcd_59(input [6:0] bin);
    reg [3:0] tens;
    reg [3:0] units;
    begin
        tens  = bin / 10;
        units = bin % 10;
        bin_to_bcd_59 = {tens, units};
    end
endfunction

// Function to convert 1-12 binary hour to BCD
function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
    begin
        if (bin_hour <= 4'd9)
            bin_to_bcd_hour = {4'd0, bin_hour};
        else
            bin_to_bcd_hour = {4'd1, bin_hour - 4'd10};
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        pm       <= 1'b0;       // AM
        hour_bin <= 4'd12;      // 12
        min_bin  <= 7'd0;
        sec_bin  <= 7'd0;
    end else if (ena) begin
        if (sec_bin == 7'd59) begin
            sec_bin <= 7'd0;
            if (min_bin == 7'd59) begin
                min_bin <= 7'd0;
                if (hour_bin == 4'd12) begin
                    hour_bin <= 4'd1;
                end else begin
                    hour_bin <= hour_bin + 4'd1;
                end
                // Toggle pm at rollover from 11 to 12
                if (hour_bin == 4'd11)
                    pm <= ~pm;
            end else begin
                min_bin <= min_bin + 7'd1;
            end
        end else begin
            sec_bin <= sec_bin + 7'd1;
        end
    end
end

// Combinational outputs
always @* begin
    hh = bin_to_bcd_hour(hour_bin);
    mm = bin_to_bcd_59(min_bin);
    ss = bin_to_bcd_59(sec_bin);
end

endmodule