module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Define an enumerated type for water levels for clarity
  localparam BELOW_S1 = 2'd0,
             BETWEEN_S2_S1 = 2'd1,
             BETWEEN_S3_S2 = 2'd2,
             ABOVE_S3 = 2'd3;

  reg [3:1] prev_s;       // Previous sensor state stored
  reg [1:0] curr_level;
  reg [1:0] prev_level;

  // Function to decode water level from sensor inputs
  function [1:0] decode_level;
    input [3:1] sensors;
    begin
      if (sensors[3] & sensors[2] & sensors[1])
        decode_level = ABOVE_S3;
      else if (sensors[2] & sensors[1] & ~sensors[3])
        decode_level = BETWEEN_S3_S2;
      else if (sensors[1] & ~sensors[2] & ~sensors[3])
        decode_level = BETWEEN_S2_S1;
      else // no sensors asserted
        decode_level = BELOW_S1;
    end
  endfunction

  // On reset, initialize previous sensor state to none asserted (lowest level)
  // with all outputs asserted.
  // Otherwise, update previous sensor and outputs based on current sensor input and level change.
  always @(posedge clk) begin
    if (reset) begin
      prev_s <= 3'b000;
      prev_level <= BELOW_S1;
      fr1 <= 1'b1;
      fr2 <= 1'b1;
      fr3 <= 1'b1;
      dfr <= 1'b1;
    end else begin
      curr_level = decode_level(s);

      // Determine if level is rising (previous level lower than current level)
      // If level rises, open supplemental valve (dfr)
      // If level falls or stays same, dfr=0
      if (curr_level > prev_level)
        dfr <= 1'b1;
      else
        dfr <= 1'b0;

      // Set nominal flow rates based on current level
      case (curr_level)
        ABOVE_S3: begin
          // no valves open
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end

        BETWEEN_S3_S2: begin
          fr1 <= 1'b1;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end

        BETWEEN_S2_S1: begin
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b0;
        end

        BELOW_S1: begin
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
        end

        default: begin
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
          dfr <= 1'b0;
        end
      endcase

      prev_s <= s;
      prev_level <= curr_level;
    end
  end

endmodule