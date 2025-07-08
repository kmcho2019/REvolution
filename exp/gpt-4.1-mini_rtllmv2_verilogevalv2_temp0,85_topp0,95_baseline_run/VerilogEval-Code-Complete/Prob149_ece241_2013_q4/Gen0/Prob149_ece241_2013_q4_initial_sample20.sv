module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // State encoding for water levels
  // 0: below s[1]
  // 1: between s[1] and s[2]
  // 2: between s[2] and s[3]
  // 3: above s[3]
  reg [1:0] current_level, previous_level;

  // Function to determine level from sensors
  // According to table:
  // s=000 => below s[1] => 0
  // s=001 => s[1] only => 1 (between s[1] and s[2])
  // s=011 => s[1], s[2] => 2 (between s[2] and s[3])
  // s=111 => s[1], s[2], s[3] => 3 (above s[3])
  // Other patterns are invalid or treated as below s[1]
  function [1:0] get_level;
    input [3:1] sensors;
    begin
      case (sensors)
        3'b000: get_level = 2'd0; // below s[1]
        3'b001: get_level = 2'd1; // between s[1] and s[2]
        3'b011: get_level = 2'd2; // between s[2] and s[3]
        3'b111: get_level = 2'd3; // above s[3]
        default: get_level = 2'd0; // treat other patterns as below s[1]
      endcase
    end
  endfunction

  always @(posedge clk) begin
    if (reset) begin
      // Reset to below s[1] state: all flow outputs asserted
      current_level <= 2'd0;
      previous_level <= 2'd0;
      fr1 <= 1'b1;
      fr2 <= 1'b1;
      fr3 <= 1'b1;
      dfr <= 1'b1;
    end else begin
      // Update level states
      previous_level <= current_level;
      current_level <= get_level(s);

      // Determine nominal flow outputs based on current level
      case (current_level)
        2'd0: begin // below s[1]
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
        end
        2'd1: begin // between s[1] and s[2]
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b0;
        end
        2'd2: begin // between s[2] and s[3]
          fr1 <= 1'b1;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end
        2'd3: begin // above s[3]
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end
        default: begin
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
        end
      endcase

      // dfr asserted if water level is rising (previous < current)
      if (current_level > previous_level)
        dfr <= 1'b1;
      else
        dfr <= 1'b0;
    end
  end

endmodule