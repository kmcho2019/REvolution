module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Function to increment a BCD digit (0-9) with carry out
function automatic [1:0] bcd_inc(input [3:0] digit);
    reg [4:0] val;
begin
    val = digit + 1;
    if (val == 10)
        bcd_inc = {1'b1, 4'd0}; // carry=1, digit=0
    else
        bcd_inc = {1'b0, val[3:0]};
end
endfunction

// Increment two BCD digits representing 00-59 or 01-12
// Returns carry out (1 if overflow)
function automatic [1:0] bcd_two_digit_inc(input [7:0] val, input integer max_tens, input integer max_ones);
    // max_tens and max_ones define max value, e.g., for 59 max_tens=5 max_ones=9
    reg [3:0] tens;
    reg [3:0] ones;
    reg carry_ones;
    reg carry_tens;
begin
    tens = val[7:4];
    ones = val[3:0];
    // increment ones digit
    {carry_ones, ones} = bcd_inc(ones);

    if (carry_ones) begin
        // increment tens digit
        {carry_tens, tens} = bcd_inc(tens);
        if (carry_tens) begin
            // overflow
            bcd_two_digit_inc = 2'b11; // carry=1, no value needed
        end else begin
            // check if tens > max_tens or (tens == max_tens and ones > max_ones)
            if ((tens > max_tens) || (tens == max_tens && ones > max_ones)) begin
                bcd_two_digit_inc = 2'b11; // overflow
            end else begin
                bcd_two_digit_inc = {1'b0,1'b0}; // no carry
            end
        end
    end else begin
        // no carry from ones digit, no overflow
        bcd_two_digit_inc = {1'b0,1'b0};
    end

    // if overflow, set to 00 (caller will handle)
end
endfunction

// But above function is complicated, simpler way:
// We'll implement seconds and minutes increment separately, checking for 59->00 rollover
// Hours increment with 12-hour logic 01-12

// To simplify, implement increment for seconds and minutes as follows:

// Increment seconds
wire sec_carry;
reg [7:0] ss_next;
always @(*) begin
    ss_next = ss;
    sec_carry = 0;

    // Increment ones digit
    if (ss[3:0] == 9) begin
        // ones digit rolls over to 0, increment tens
        ss_next[3:0] = 4'd0;
        if (ss[7:4] == 5) begin
            // tens digit rolls over to 0 -> seconds go from 59 to 00
            ss_next[7:4] = 4'd0;
            sec_carry = 1;
        end else begin
            ss_next[7:4] = ss[7:4] + 1;
            sec_carry = 0;
        end
    end else begin
        // simply increment ones digit
        ss_next[3:0] = ss[3:0] + 1;
        ss_next[7:4] = ss[7:4];
        sec_carry = 0;
    end
end

// Increment minutes similarly
wire min_carry;
reg [7:0] mm_next;
always @(*) begin
    mm_next = mm;
    min_carry = 0;

    if (mm[3:0] == 9) begin
        mm_next[3:0] = 4'd0;
        if (mm[7:4] == 5) begin
            mm_next[7:4] = 4'd0;
            min_carry = 1;
        end else begin
            mm_next[7:4] = mm[7:4] + 1;
            min_carry = 0;
        end
    end else begin
        mm_next[3:0] = mm[3:0] + 1;
        mm_next[7:4] = mm[7:4];
        min_carry = 0;
    end
end

// Increment hours: 12-hour format BCD, ranges 01-12
// On overflow (12->1), toggle pm
reg pm_next;
reg [7:0] hh_next;

always @(*) begin
    pm_next = pm;
    hh_next = hh;
    // Convert hh to integer for easier handling
    integer hh_int;
    hh_int = hh[7:4]*10 + hh[3:0];
    if (hh_int < 1) hh_int = 1;
    if (hh_int > 12) hh_int = 12;

    if (hh_int == 12) begin
        // roll to 1 and toggle pm
        hh_next[7:4] = 4'd0;
        hh_next[3:0] = 4'd1;
        pm_next = ~pm;
    end else begin
        // increment hour
        hh_int = hh_int + 1;
        hh_next[7:4] = hh_int / 10;
        hh_next[3:0] = hh_int % 10;
    end
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00 AM
        hh <= 8'h12; // 0x12 BCD = 12
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0;
    end else if (ena) begin
        // Increment seconds
        if (sec_carry) begin
            ss <= 8'h00;
            // Increment minutes
            if (min_carry) begin
                mm <= 8'h00;
                // Increment hours
                hh <= hh_next;
                pm <= pm_next;
            end else begin
                mm <= mm_next;
            end
        end else begin
            ss <= ss_next;
        end
    end
end

endmodule