module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

// BCD increment function for two-digit BCD counting from 00 to 59
function [7:0] bcd_inc_59;
  input [7:0] bcd;
  begin
    if (bcd[3:0] == 4'd9) begin
      if (bcd[7:4] == 4'd5)
        bcd_inc_59 = 8'd0; // 59 -> 00 rollover
      else
        bcd_inc_59 = {bcd[7:4] + 4'd1, 4'd0};
    end else begin
      bcd_inc_59 = {bcd[7:4], bcd[3:0] + 4'd1};
    end
  end
endfunction

// BCD increment function for hours (01 to 12)
function [7:0] bcd_inc_12;
  input [7:0] bcd;
  begin
    // Convert BCD hour to decimal integer
    integer hour;
    hour = bcd[7:4]*10 + bcd[3:0];

    if (hour == 12)
      hour = 1;
    else
      hour = hour + 1;

    // Convert back to BCD
    bcd_inc_12 = {(hour/10), (hour%10)};
  end
endfunction

// Check if hour BCD is 11 (for PM toggle logic)
function is_eleven;
  input [7:0] bcd;
  begin
    is_eleven = (bcd == 8'h11); // BCD 11
  end
endfunction

// Check if hour BCD is 12
function is_twelve;
  input [7:0] bcd;
  begin
    is_twelve = (bcd == 8'h12); // BCD 12
  end
endfunction

always @(posedge clk) begin
  if (reset) begin
    // Reset to 12:00:00 AM
    hh <= 8'h12;
    mm <= 8'h00;
    ss <= 8'h00;
    pm <= 1'b0;
  end else if (ena) begin
    // Increment seconds
    if (ss == 8'h59) begin
      ss <= 8'h00;
      // Increment minutes
      if (mm == 8'h59) begin
        mm <= 8'h00;
        // Increment hours
        if (hh == 8'h12) begin
          hh <= 8'h01;
          // Toggle pm when hour rolls from 12 to 1
          pm <= ~pm;
        end else begin
          hh <= bcd_inc_12(hh);
        end
      end else begin
        mm <= bcd_inc_59(mm);
      end
    end else begin
      ss <= bcd_inc_59(ss);
    end
  end
end

endmodule