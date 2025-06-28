module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

reg [3:0] seconds_counter = 0;
reg [3:0] minutes_counter = 0;
reg [3:0] hours_counter = 0;

always @(posedge clk) begin
  if (reset) begin
    seconds_counter <= 4'b0;
    minutes_counter <= 4'b0;
    hours_counter <= 4'b0;
    hh <= 8'b00000001; // Set initial hour to 1 (12:00 AM)
    mm <= 8'b00000000; // Set initial minute to 0
    ss <= 8'b00000000; // Set initial second to 0 
    pm <= 1'b0; // Reset to AM
  end 
  else if (ena) begin
    seconds_counter <= seconds_counter + 1;
    if (seconds_counter == 10) begin
      seconds_counter <= 4'b0;
      mm <= mm + 1;
      if (mm == 60) begin
        mm <= 8'b00000000;
        hh <= hh + 1;
        if (hh == 8'b00011000 || hh == 8'b00011001) begin // 18 or 19
          hh <= 8'b00000001;
          pm <= ~pm; // Toggle AM/PM
        end 
        if (hh == 13) begin
          hh <= 8'b00000001;
        end 
      end 
    end 
  end 
end

endmodule