module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

// Helper function: increment BCD (0-9) digit, returns new digit and carry
function [1:0] bcd_inc_digit;
  input [3:0] digit;
  reg [3:0] next_digit;
  reg carry_out;
begin
  if (digit == 4'd9) begin
    next_digit = 4'd0;
    carry_out = 1'b1;
  end else begin
    next_digit = digit + 4'd1;
    carry_out = 1'b0;
  end
  bcd_inc_digit = {carry_out, next_digit};
end
endfunction

// Increment seconds (00-59) in BCD
task inc_seconds;
  output reg sec_carry;
  reg carry_ones, carry_tens;
  reg [3:0] ones, tens;
  reg [4:0] val; // to check decimal value (0-9, 0-5)
begin
  ones = ss[3:0];
  tens = ss[7:4];

  // increment ones digit
  {carry_ones, ones} = bcd_inc_digit(ones);

  if (carry_ones) begin
    // increment tens digit
    if (tens == 4'd5) begin
      tens = 4'd0;
      sec_carry = 1'b1; // seconds rolled over from 59 to 00
    end else begin
      tens = tens + 4'd1;
      sec_carry = 1'b0;
    end
  end else begin
    sec_carry = 1'b0;
  end

  ss = {tens, ones};
end
endtask

// Increment minutes (00-59) in BCD
task inc_minutes;
  output reg min_carry;
  reg carry_ones, carry_tens;
  reg [3:0] ones, tens;
begin
  ones = mm[3:0];
  tens = mm[7:4];

  {carry_ones, ones} = bcd_inc_digit(ones);

  if (carry_ones) begin
    if (tens == 4'd5) begin
      tens = 4'd0;
      min_carry = 1'b1; // minutes rolled over from 59 to 00
    end else begin
      tens = tens + 4'd1;
      min_carry = 1'b0;
    end
  end else begin
    min_carry = 1'b0;
  end

  mm = {tens, ones};
end
endtask

// Increment hours (01-12) in BCD
task inc_hours;
  output reg hour_rollover;
  reg [3:0] ones, tens;
  reg [7:0] new_hh;
  reg [7:0] next_hh;
  reg carry_ones;
begin
  ones = hh[3:0];
  tens = hh[7:4];

  // Convert current hh BCD to decimal number (1-12)
  // We'll increment and wrap manually
  integer dec_hh;
  dec_hh = tens*10 + ones;

  dec_hh = dec_hh + 1;
  if (dec_hh == 13)
    dec_hh = 1;

  hour_rollover = (dec_hh == 12);

  // Convert back to BCD
  tens = dec_hh / 10;
  ones = dec_hh % 10;

  hh = {tens[3:0], ones[3:0]};
end
endtask

always @(posedge clk) begin
  if (reset) begin
    // reset to 12:00:00 AM
    hh <= 8'h12;  // 0x12 BCD for 12
    mm <= 8'h00;
    ss <= 8'h00;
    pm <= 1'b0;
  end else if (ena) begin
    reg sec_roll;
    reg min_roll;
    reg hour_roll;
    // increment seconds
    inc_seconds(sec_roll);

    if (sec_roll) begin
      inc_minutes(min_roll);
      if (min_roll) begin
        inc_hours(hour_roll);
        if (hour_roll) begin
          pm <= ~pm; // toggle pm on hour rollover from 11 to 12
        end
      end
    end
  end
end

endmodule