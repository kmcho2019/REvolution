module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Define water level states
  localparam LEVEL_0 = 2'd0; // Below s[1] (no sensors asserted)
  localparam LEVEL_1 = 2'd1; // Between s[2] and s[1] (only s[1])
  localparam LEVEL_2 = 2'd2; // Between s[3] and s[2] (s[1], s[2])
  localparam LEVEL_3 = 2'd3; // Above s[3] (s[1], s[2], s[3])

  reg [1:0] current_level, previous_level;

  // Function to decode water level from sensors s[3:1]
  // Sensors are active high
  function [1:0] decode_level;
    input [3:1] sensors;
    begin
      if (sensors[3] & sensors[2] & sensors[1])
        decode_level = LEVEL_3;
      else if (sensors[2] & sensors[1])
        decode_level = LEVEL_2;
      else if (sensors[1])
        decode_level = LEVEL_1;
      else
        decode_level = LEVEL_0;
    end
  endfunction

  always @(posedge clk) begin
    if (reset) begin
      current_level <= LEVEL_0;
      previous_level <= LEVEL_0;
      fr1 <= 1'b1;
      fr2 <= 1'b1;
      fr3 <= 1'b1;
      dfr <= 1'b1;
    end else begin
      // Update previous_level before updating current_level
      previous_level <= current_level;
      current_level <= decode_level(s);

      // Determine outputs based on current_level and previous_level
      case (current_level)
        LEVEL_3: begin
          // Above s[3]: no flows
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
          dfr <= 1'b0;
        end
        LEVEL_2: begin
          // fr1 only nominal
          fr1 <= 1'b1;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
          // dfr if current > previous
          dfr <= (current_level > previous_level) ? 1'b1 : 1'b0;
        end
        LEVEL_1: begin
          // fr1 and fr2 nominal
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b0;
          dfr <= (current_level > previous_level) ? 1'b1 : 1'b0;
        end
        LEVEL_0: begin
          // fr1, fr2, fr3 nominal (max flow)
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
          dfr <= 1'b1; // As per spec, all four outputs asserted here
        end
        default: begin
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
          dfr <= 1'b0;
        end
      endcase
    end
  end

endmodule