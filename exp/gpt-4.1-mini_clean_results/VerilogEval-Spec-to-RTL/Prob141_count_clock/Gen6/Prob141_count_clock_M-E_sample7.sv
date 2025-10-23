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
reg [5:0] sec_bin;   // 0-59
reg [5:0] min_bin;   // 0-59
reg [3:0] hour_bin;  // 1-12

// Binary to BCD converter for 0-59 (minutes and seconds)
function [7:0] bin_to_bcd_0_59;
    input [5:0] val;
    reg [3:0] tens;
    reg [3:0] units;
    begin
        tens  = val / 6'd10;
        units = val % 6'd10;
        bin_to_bcd_0_59 = {tens, units};
    end
endfunction

// Binary to BCD converter for 1-12 hours
function [7:0] bin_to_bcd_hour;
    input [3:0] val;
    reg [3:0] tens;
    reg [3:0] units;
    begin
        if (val < 10) begin
            tens  = 4'd0;
            units = val[3:0];
        end else begin
            tens  = 4'd1;
            units = val - 4'd10;
        end
        bin_to_bcd_hour = {tens, units};
    end
endfunction

// Sequential logic: counters update
always @(posedge clk) begin
    if (reset) begin
        pm      <= 1'b0;   // AM
        hour_bin <= 4'd12; // 12
        min_bin <= 6'd0;
        sec_bin <= 6'd0;
    end else if (ena) begin
        // Increment seconds
        if (sec_bin == 6'd59) begin
            sec_bin <= 6'd0;
            // Increment minutes
            if (min_bin == 6'd59) begin
                min_bin <= 6'd0;
                // Increment hours 1-12 with wrap and pm toggle
                if (hour_bin == 4'd12) begin
                    hour_bin <= 4'd1;
                    pm <= ~pm;
                end else begin
                    hour_bin <= hour_bin + 4'd1;
                end
            end else begin
                min_bin <= min_bin + 6'd1;
            end
        end else begin
            sec_bin <= sec_bin + 6'd1;
        end
    end
end

// Combinational outputs converted to BCD format
always @* begin
    hh = bin_to_bcd_hour(hour_bin);
    mm = bin_to_bcd_0_59(min_bin);
    ss = bin_to_bcd_0_59(sec_bin);
end

endmodule