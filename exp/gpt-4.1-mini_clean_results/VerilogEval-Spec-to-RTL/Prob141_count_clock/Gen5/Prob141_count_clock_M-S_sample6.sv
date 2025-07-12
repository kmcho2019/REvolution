module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal binary counters for hours (0-11, representing 1-12), minutes and seconds in BCD digits
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;
reg [3:0] hh_bin;  // 0 to 11 for hours 1 to 12

// BCD increment function for units digit with max 9
function [3:0] bcd_inc_9(input [3:0] val);
    begin
        bcd_inc_9 = (val == 4'd9) ? 4'd0 : val + 4'd1;
    end
endfunction

// BCD increment function for tens digit with max 5
function [3:0] bcd_inc_5(input [3:0] val);
    begin
        bcd_inc_5 = (val == 4'd5) ? 4'd0 : val + 4'd1;
    end
endfunction

// Convert hour binary (0..11) to BCD (01..12)
function [7:0] hour_bin_to_bcd(input [3:0] hb);
    reg [7:0] result;
    begin
        case(hb)
            4'd0:  result = 8'h12; // 12
            4'd1:  result = 8'h01;
            4'd2:  result = 8'h02;
            4'd3:  result = 8'h03;
            4'd4:  result = 8'h04;
            4'd5:  result = 8'h05;
            4'd6:  result = 8'h06;
            4'd7:  result = 8'h07;
            4'd8:  result = 8'h08;
            4'd9:  result = 8'h09;
            4'd10: result = 8'h10;
            4'd11: result = 8'h11;
            default: result = 8'h00; // invalid, shouldn't happen
        endcase
        hour_bin_to_bcd = result;
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        // reset to 12:00:00 AM
        pm <= 1'b0;
        hh_bin <= 4'd0;  // 12 hour
        mm_tens <= 4'd0;
        mm_units <= 4'd0;
        ss_tens <= 4'd0;
        ss_units <= 4'd0;
    end else if (ena) begin
        // increment seconds units
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;
                // increment minutes units
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                        // increment hour binary counter
                        if (hh_bin == 4'd11) begin
                            hh_bin <= 4'd0;
                            pm <= ~pm;  // toggle pm when hour wraps
                        end else begin
                            hh_bin <= hh_bin + 4'd1;
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

// Output combinational assignments for hh, mm, ss as BCD
always @(*) begin
    hh = hour_bin_to_bcd(hh_bin);
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule