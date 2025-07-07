module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Function to map sensor pattern to water level number:
  // 0 = below s[1] (no sensors asserted)
  // 1 = between s[2] and s[1] (only s[1] asserted)
  // 2 = between s[3] and s[2] (s[1] and s[2] asserted)
  // 3 = above s[3] (all sensors asserted)
  function [1:0] sensor_level;
    input [3:1] sensors;
    begin
      if (sensors == 3'b111)      sensor_level = 2'd3;
      else if (sensors == 3'b110) sensor_level = 2'd2;
      else if (sensors == 3'b100) sensor_level = 2'd1;
      else                        sensor_level = 2'd0;
    end
  endfunction

  reg [1:0] prev_level;

  always @(posedge clk) begin
    if (reset) begin
      // Reset to low water level state: no sensors asserted, all outputs asserted
      prev_level <= 2'd0;
      fr1 <= 1'b1;
      fr2 <= 1'b1;
      fr3 <= 1'b1;
      dfr <= 1'b1;
    end else begin
      // Determine current water level
      reg [1:0] curr_level;
      curr_level = sensor_level(s);

      // Determine if water level is rising (current > previous)
      reg rising;
      rising = (curr_level > prev_level);

      // Update outputs based on current level and rising flag
      case (curr_level)
        2'd3: begin // Above s[3]
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
          dfr <= 1'b0;
        end
        2'd2: begin // Between s[3] and s[2]
          fr1 <= 1'b1;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
          dfr <= rising ? 1'b1 : 1'b0;
        end
        2'd1: begin // Between s[2] and s[1]
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b0;
          dfr <= rising ? 1'b1 : 1'b0;
        end
        2'd0: begin // Below s[1]
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
          dfr <= rising ? 1'b1 : 1'b0;
        end
        default: begin
          // Should not occur, but safe defaults
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
          dfr <= 1'b1;
        end
      endcase

      // Update previous level for next cycle
      prev_level <= curr_level;
    end
  end

endmodule