module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Separate BCD digits for seconds and minutes
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;

// Separate BCD digits for hours
reg [7:0] hour_bcd; // store full hour BCD (tens + units) for easier hour increment function
wire [3:0] hh_tens = hour_bcd[7:4];
wire [3:0] hh_units = hour_bcd[3:0];

// Increment BCD digit with max limit
function [3:0] bcd_inc_digit(input [3:0] val, input [3:0] max);
begin
    if (val == max)
        bcd_inc_digit = 4'd0;
    else
        bcd_inc_digit = val + 4'd1;
end
endfunction

// BCD increment for seconds and minutes (00-59)
function [7:0] bcd_inc_59(input [7:0] val);
    reg [3:0] units, tens;
    begin
        units = val[3:0];
        tens  = val[7:4];
        if (units == 4'd9) begin
            units = 4'd0;
            if (tens == 4'd5)
                tens = 4'd0;
            else
                tens = tens + 4'd1;
        end else begin
            units = units + 4'd1;
        end
        bcd_inc_59 = {tens, units};
    end
endfunction

// Check if BCD value equals 59
function is_59(input [7:0] val);
    begin
        is_59 = (val == 8'h59);
    end
endfunction

// Increment hour in 12-hour BCD (01 to 12)
function [7:0] hour_inc(input [7:0] curr);
    reg [3:0] h_tens, h_units;
    begin
        h_tens  = curr[7:4];
        h_units = curr[3:0];
        if (curr == 8'h12)
            hour_inc = 8'h01;
        else if (curr == 8'h09)
            hour_inc = 8'h10; // 9 -> 10
        else begin
            // increment units digit
            if (h_units == 4'd9) begin
                h_units = 4'd0;
                h_tens = h_tens + 4'd1;
            end else begin
                h_units = h_units + 4'd1;
            end
            hour_inc = {h_tens, h_units};
        end
    end
endfunction

// Detect hour rollover for PM toggle (11 -> 12)
wire hour_will_rollover = (hour_bcd == 8'h11);

always @(posedge clk) begin
    if (reset) begin
        // Reset all registers
        pm       <= 1'b0;      // AM
        hour_bcd <= 8'h12;     // 12
        mm_tens  <= 4'd0;
        mm_units <= 4'd0;
        ss_tens  <= 4'd0;
        ss_units <= 4'd0;
    end else if (ena) begin
        // Increment seconds
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;
                // Increment minutes
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                        // Increment hours
                        if (hour_will_rollover) begin
                            // Hour rolls from 11 to 12: toggle pm
                            pm       <= ~pm;
                            hour_bcd <= 8'h12;
                        end else if (hour_bcd == 8'h12) begin
                            // Hour rolls from 12 to 01
                            hour_bcd <= 8'h01;
                        end else begin
                            hour_bcd <= hour_inc(hour_bcd);
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

// Combine BCD digits for outputs (combinational)
always @(*) begin
    hh = hour_bcd;
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule