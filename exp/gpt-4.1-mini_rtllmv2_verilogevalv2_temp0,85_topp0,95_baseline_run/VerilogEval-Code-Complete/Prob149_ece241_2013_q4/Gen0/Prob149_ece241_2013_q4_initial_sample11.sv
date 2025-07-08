module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Water level states
  localparam BELOW_S1 = 2'd0;
  localparam BETWEEN_S2_S1 = 2'd1;
  localparam BETWEEN_S3_S2 = 2'd2;
  localparam ABOVE_S3 = 2'd3;

  reg [1:0] curr_level, prev_level;

  // Function to decode sensors into water level
  // Based on which sensors are asserted:
  // s[3]=highest, s[1]=lowest sensor
  function [1:0] decode_level;
    input [3:1] sensors;
    begin
      if (sensors[3] && sensors[2] && sensors[1])
        decode_level = ABOVE_S3;
      else if (!sensors[3] && sensors[2] && sensors[1])
        decode_level = BETWEEN_S3_S2;
      else if (!sensors[3] && !sensors[2] && sensors[1])
        decode_level = BETWEEN_S2_S1;
      else // no sensors asserted
        decode_level = BELOW_S1;
    end
  endfunction

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      // Reset state: below s1, all valves open including dfr
      curr_level <= BELOW_S1;
      prev_level <= BELOW_S1;
      fr1 <= 1'b1;
      fr2 <= 1'b1;
      fr3 <= 1'b1;
      dfr <= 1'b1;
    end else begin
      curr_level <= decode_level(s);

      // Determine outputs based on curr_level
      case (curr_level)
        ABOVE_S3: begin
          // Above highest sensor: no valves open
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end
        BETWEEN_S3_S2: begin
          // between s3 and s2: fr1 only
          fr1 <= 1'b1;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end
        BETWEEN_S2_S1: begin
          // between s2 and s1: fr1, fr2
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b0;
        end
        BELOW_S1: begin
          // below s1: fr1, fr2, fr3
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
        end
        default: begin
          // default safe state: all valves open
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
        end
      endcase

      // dfr is set if current level is higher than previous level (water rising)
      if (curr_level > prev_level)
        dfr <= 1'b1;
      else
        dfr <= 1'b0;

      prev_level <= curr_level;
    end
  end

endmodule