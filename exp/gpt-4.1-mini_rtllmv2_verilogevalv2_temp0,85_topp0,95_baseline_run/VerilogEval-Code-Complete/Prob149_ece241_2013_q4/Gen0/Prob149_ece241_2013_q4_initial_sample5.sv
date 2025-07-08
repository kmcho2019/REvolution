module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Define states representing water level categories
  localparam STATE_0 = 2'd0; // below s[1]: no sensors
  localparam STATE_1 = 2'd1; // between s[2] and s[1]: s[1] only
  localparam STATE_2 = 2'd2; // between s[3] and s[2]: s[1], s[2]
  localparam STATE_3 = 2'd3; // above s[3]: s[1], s[2], s[3]

  reg [1:0] current_level, prev_level;

  // Function to decode sensors into level state
  // Priority from highest to lowest level
  function [1:0] decode_level(input [3:1] sensors);
    begin
      if (sensors[3] && sensors[2] && sensors[1])
        decode_level = STATE_3;
      else if (sensors[2] && sensors[1])
        decode_level = STATE_2;
      else if (sensors[1])
        decode_level = STATE_1;
      else
        decode_level = STATE_0;
    end
  endfunction

  // Synchronous logic: update levels and outputs
  always @(posedge clk) begin
    if (reset) begin
      // Reset to lowest water level and all flow valves open
      current_level <= STATE_0;
      prev_level <= STATE_0;
      fr1 <= 1'b1;
      fr2 <= 1'b1;
      fr3 <= 1'b1;
      dfr <= 1'b1;
    end else begin
      // Update current water level from sensors
      current_level <= decode_level(s);

      // Determine outputs based on current level
      case (decode_level(s))
        STATE_3: begin
          // Above s[3]: no flow
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end
        STATE_2: begin
          // Between s[3] and s[2]: fr1 asserted
          fr1 <= 1'b1;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end
        STATE_1: begin
          // Between s[2] and s[1]: fr1 and fr2 asserted
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b0;
        end
        STATE_0: begin
          // Below s[1]: fr1, fr2, fr3 asserted
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
        end
        default: begin
          // Default safe values (should not occur)
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end
      endcase

      // Determine dfr - assert supplemental valve if level increased
      // Compare current level to previous level
      if (decode_level(s) > prev_level)
        dfr <= 1'b1;
      else
        dfr <= 1'b0;

      // Update previous level for next cycle
      prev_level <= decode_level(s);
    end
  end

endmodule