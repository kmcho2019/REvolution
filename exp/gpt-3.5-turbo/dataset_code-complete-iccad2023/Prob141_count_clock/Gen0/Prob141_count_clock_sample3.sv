module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);

reg [3:0] seconds_tens, seconds_ones, minutes_tens, minutes_ones, hours_tens, hours_ones;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    seconds_tens <= 4'b0000;
    seconds_ones <= 4'b0000;
    minutes_tens <= 4'b0000;
    minutes_ones <= 4'b0000;
    hours_tens <= 4'b0001; // Initialize to 1
    hours_ones <= 4'b0010; // Initialize to 2 (12:00 AM)
    pm <= 1'b0; // AM
  end else if (ena) begin
    // Increment seconds
    if (seconds_ones == 4'b1001) begin
      seconds_ones <= 4'b0000;
      if (seconds_tens == 4'b0000) begin
        seconds_tens <= 4'b0001;
        // Increment minutes
        if (minutes_ones == 4'b1001) begin
          minutes_ones <= 4'b0000;
          if (minutes_tens == 4'b0000) begin
            minutes_tens <= 4'b0001;
            // Increment hours
            if (hours_ones == 4'b1001) begin
              hours_ones <= 4'b0001;
              if (hours_tens == 4'b0000) begin
                hours_tens <= 4'b0001;
                // Handle transition to PM
                pm <= ~pm;
              end
            end else begin
              hours_ones <= hours_ones + 1;
            end
          end
        end else begin
          minutes_ones <= minutes_ones + 1;
        end
      end
    end else begin
      seconds_ones <= seconds_ones + 1;
    end
  end
end

assign ss = {seconds_tens, seconds_ones};
assign mm = {minutes_tens, minutes_ones};
assign hh = {hours_tens, hours_ones};

endmodule