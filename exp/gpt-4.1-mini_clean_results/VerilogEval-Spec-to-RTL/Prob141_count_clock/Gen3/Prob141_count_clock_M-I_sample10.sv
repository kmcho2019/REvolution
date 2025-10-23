module TopModule (
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Localparams for constants
localparam [7:0] BCD_59 = 8'h59;
localparam [7:0] BCD_12 = 8'h12;
localparam [7:0] BCD_11 = 8'h11;
localparam [7:0] BCD_01 = 8'h01;
localparam [7:0] BCD_00 = 8'h00;

// -----------------------
// BCD increment for 00..59
function [7:0] bcd_inc_59(input [7:0] val);
    reg [3:0] tens, ones;
    begin
        tens = val[7:4];
        ones = val[3:0];
        if (ones == 4'd9) begin
            ones = 4'd0;
            if (tens == 4'd5)
                tens = 4'd0;
            else
                tens = tens + 4'd1;
        end else begin
            ones = ones + 4'd1;
        end
        bcd_inc_59 = {tens, ones};
    end
endfunction

// Increment hour from 01..12, wrap to 01 after 12
function [7:0] hour_inc_12(input [7:0] val);
    reg [3:0] tens, ones;
    reg [7:0] next_h;
    begin
        tens = val[7:4];
        ones = val[3:0];
        // Increment ones digit
        if (ones == 4'd9) begin
            ones = 4'd0;
            tens = tens + 4'd1;
        end else begin
            ones = ones + 4'd1;
        end
        next_h = {tens, ones};
        // Wrap after 12 to 01
        if ((tens > 4'd1) || (tens == 4'd1 && ones > 4'd2)) begin
            next_h = BCD_01;
        end else if (next_h == BCD_00) begin
            // No zero hour, wrap to 1
            next_h = BCD_01;
        end
        hour_inc_12 = next_h;
    end
endfunction

// Combinational logic block for next states
reg [7:0] next_ss, next_mm, next_hh;
reg next_pm;

wire seconds_rollover, minutes_rollover, hour_rollover;
wire toggle_pm_flag;

always @* begin
    // Default assignments
    next_ss = ss;
    next_mm = mm;
    next_hh = hh;
    next_pm = pm;

    // Seconds increment logic
    if (ena) begin
        next_ss = bcd_inc_59(ss);
    end

    seconds_rollover = (ss == BCD_59) && ena;

    // Minutes increment logic
    if (seconds_rollover) begin
        next_mm = bcd_inc_59(mm);
    end

    minutes_rollover = (mm == BCD_59) && seconds_rollover;

    // Hours increment logic and PM toggle decision
    if (minutes_rollover) begin
        // Determine if hour currently is 11 (before increment)
        toggle_pm_flag = (hh == BCD_11);

        next_hh = hour_inc_12(hh);

        // Toggle pm when incrementing from 11 to 12
        if (toggle_pm_flag) begin
            next_pm = ~pm;
        end
    end
end

// Sequential logic: registers update on posedge clk
always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00:00 AM
        hh <= BCD_12;
        mm <= BCD_00;
        ss <= BCD_00;
        pm <= 1'b0;
    end else begin
        // Update registers only if enabled or resetting
        if (ena) begin
            ss <= next_ss;
            mm <= next_mm;
            hh <= next_hh;
            pm <= next_pm;
        end
    end
end

endmodule