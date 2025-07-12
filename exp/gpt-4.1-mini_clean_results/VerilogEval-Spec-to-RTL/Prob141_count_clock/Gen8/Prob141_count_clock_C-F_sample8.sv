module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal BCD digits for seconds and minutes
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;

// Internal binary hour counter (1 to 12)
reg [3:0] hour_bin;  // 4-bit binary counter for hours 1..12

// Functions for incrementing BCD digits with max value
function [3:0] inc_bcd_digit(input [3:0] digit, input [3:0] max_val);
    begin
        if (digit == max_val)
            inc_bcd_digit = 4'd0;
        else
            inc_bcd_digit = digit + 4'd1;
    end
endfunction

// Increment seconds BCD (00 to 59)
function [7:0] inc_bcd_59(input [7:0] val);
    reg [3:0] units, tens;
    begin
        units = val[3:0];
        tens = val[7:4];
        if (units == 4'd9) begin
            units = 4'd0;
            if (tens == 4'd5)
                tens = 4'd0;
            else
                tens = tens + 4'd1;
        end else begin
            units = units + 4'd1;
        end
        inc_bcd_59 = {tens, units};
    end
endfunction

// Check if BCD equals 59 (for minutes/seconds)
function is_59(input [7:0] val);
    begin
        is_59 = (val == 8'h59);
    end
endfunction

// Convert binary hour (1..12) to BCD
function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
    reg [7:0] val;
    begin
        if (bin_hour <= 4'd9)
            val = {4'd0, bin_hour};
        else
            val = {4'd1, bin_hour - 4'd10};
        bin_to_bcd_hour = val;
    end
endfunction

// Next state variables for seconds and minutes
wire [7:0] next_ss;
wire [7:0] next_mm;
wire ss_rollover;
wire mm_rollover;
wire hour_inc;

// Calculate next seconds value and detect rollover
assign next_ss = ena ? inc_bcd_59({ss_tens, ss_units}) : {ss_tens, ss_units};
assign ss_rollover = ena && is_59({ss_tens, ss_units});

// Calculate next minutes value and detect rollover if seconds roll over
assign next_mm = (ena && ss_rollover) ? inc_bcd_59({mm_tens, mm_units}) : {mm_tens, mm_units};
assign mm_rollover = (ena && ss_rollover) && is_59({mm_tens, mm_units});

// Hour increment happens when minutes roll over from 59 to 00
assign hour_inc = mm_rollover;

// Detect hour roll from 11 to 12 to toggle PM
wire toggle_pm = (hour_bin == 4'd11) && hour_inc;

always @(posedge clk) begin
    if (reset) begin
        pm       <= 1'b0;       // AM
        hour_bin <= 4'd12;      // 12
        mm_tens  <= 4'd0;
        mm_units <= 4'd0;
        ss_tens  <= 4'd0;
        ss_units <= 4'd0;
    end else begin
        // Update seconds
        ss_tens  <= next_ss[7:4];
        ss_units <= next_ss[3:0];

        // Update minutes
        mm_tens  <= next_mm[7:4];
        mm_units <= next_mm[3:0];

        // Update hours with 1..12 wrap-around
        if (hour_inc) begin
            if (hour_bin == 4'd12)
                hour_bin <= 4'd1;
            else
                hour_bin <= hour_bin + 4'd1;
        end

        // Toggle PM on 11->12 transition
        if (toggle_pm)
            pm <= ~pm;
    end
end

// Combinational output assignments
always @* begin
    hh = bin_to_bcd_hour(hour_bin);
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule