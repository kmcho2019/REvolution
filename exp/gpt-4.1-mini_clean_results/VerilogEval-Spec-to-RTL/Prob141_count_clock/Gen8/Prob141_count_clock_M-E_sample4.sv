module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Seconds: two BCD digits
reg [3:0] ss_units;
reg [3:0] ss_tens;

// Minutes: two BCD digits
reg [3:0] mm_units;
reg [3:0] mm_tens;

// Hours: two BCD digits (01 to 12)
reg [3:0] hh_units;
reg [3:0] hh_tens;

// Helper function: Increment BCD digit with max value rollover
function [3:0] bcd_inc(input [3:0] digit, input [3:0] max);
    begin
        if (digit == max)
            bcd_inc = 4'd0;
        else
            bcd_inc = digit + 4'd1;
    end
endfunction

// Helper function: Is BCD digit equal to a value?
function bcd_eq(input [3:0] digit, input [3:0] val);
    begin
        bcd_eq = (digit == val);
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00:00 AM
        pm       <= 1'b0;        // AM
        hh_tens  <= 4'd1;        // '1'
        hh_units <= 4'd2;        // '2'
        mm_tens  <= 4'd0;
        mm_units <= 4'd0;
        ss_tens  <= 4'd0;
        ss_units <= 4'd0;
    end else if (ena) begin
        // Seconds units increment
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            // Seconds tens increment
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;
                // Minutes units increment
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    // Minutes tens increment
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                        // Hours increment with special 12-hour rollover and PM toggle

                        // Current hour as two BCD digits: hh_tens, hh_units
                        // Increment hour by 1, rollover after 12 -> 01
                        // Toggle pm when rolling from 11 to 12

                        if ((hh_tens == 4'd1 && hh_units == 4'd1)) begin
                            // Hour = 11, next hour = 12, toggle pm
                            hh_tens <= 4'd1;
                            hh_units <= 4'd2;
                            pm <= ~pm;
                        end else if ((hh_tens == 4'd1 && hh_units == 4'd2)) begin
                            // Hour = 12, rollover to 01, pm unchanged
                            hh_tens <= 4'd0;
                            hh_units <= 4'd1;
                        end else begin
                            // Normal increment hour units or tens
                            if (hh_units == 4'd9) begin
                                hh_units <= 4'd0;
                                hh_tens <= hh_tens + 4'd1;
                            end else begin
                                hh_units <= hh_units + 4'd1;
                            end
                        end
                    end else begin
                        mm_tens <= mm_tens + 4'd1;
                    end
                end else begin
                    mm_units <= mm_units + 4'd1;
                end
            end else begin
                ss_tens <= ss_tens + 4'd1;
            end
        end else begin
            ss_units <= ss_units + 4'd1;
        end
    end
end

// Output concatenations of BCD digits
always @(*) begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule