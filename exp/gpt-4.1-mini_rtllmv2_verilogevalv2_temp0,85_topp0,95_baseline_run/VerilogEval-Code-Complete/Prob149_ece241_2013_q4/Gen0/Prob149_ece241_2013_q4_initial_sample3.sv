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
  typedef enum logic [1:0] {
    BELOW_S1 = 2'b00,
    BETWEEN_S2_S1 = 2'b01,
    BETWEEN_S3_S2 = 2'b10,
    ABOVE_S3 = 2'b11
  } water_level_t;

  water_level_t current_level, prev_level;

  // Function to decode sensors into water level
  function water_level_t decode_level(input [3:1] sensors);
    begin
      case (sensors)
        3'b111: decode_level = ABOVE_S3;         // Above s3
        3'b110: decode_level = BETWEEN_S3_S2;   // Between s3 and s2
        3'b100: decode_level = BETWEEN_S2_S1;   // Between s2 and s1
        3'b000: decode_level = BELOW_S1;         // Below s1
        // For any other sensor combinations, map conservatively:
        3'b011: decode_level = BETWEEN_S3_S2; // s2 and s1 asserted, treat as between s3 and s2
        3'b010: decode_level = BETWEEN_S2_S1; // only s2 asserted, treat as between s2 and s1
        3'b001: decode_level = BELOW_S1;       // only s1 asserted, treat as below s1? But specs say below s1 none asserted, so treat 001 as below s1 also
        3'b101: decode_level = BETWEEN_S3_S2;  // s3 and s1 asserted, treat as between s3 and s2 (safe)
        3'b111: decode_level = ABOVE_S3;       // redundant
        default: decode_level = BELOW_S1;      // default to below s1 for safety
      endcase
    end
  endfunction

  // Compare water levels to determine if current > previous
  // Define order BELOW_S1 < BETWEEN_S2_S1 < BETWEEN_S3_S2 < ABOVE_S3
  function logic rising_level(input water_level_t prev, input water_level_t curr);
    begin
      rising_level = (curr > prev);
    end
  endfunction

  always @(posedge clk) begin
    if (reset) begin
      // Reset to below s1 (lowest level) with all flow valves and dfr asserted
      current_level <= BELOW_S1;
      prev_level <= BELOW_S1;
      fr1 <= 1'b1;
      fr2 <= 1'b1;
      fr3 <= 1'b1;
      dfr <= 1'b1;
    end else begin
      prev_level <= current_level;
      current_level <= decode_level(s);

      // Determine if water level is rising
      logic rising;
      rising = rising_level(prev_level, current_level);

      // Set outputs according to current_level and rising condition
      case (current_level)
        ABOVE_S3: begin
          // all sensors asserted, flow zero
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
          dfr <= 1'b0;
        end
        BETWEEN_S3_S2: begin
          fr1 <= 1'b1;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
          dfr <= rising ? 1'b1 : 1'b0;
        end
        BETWEEN_S2_S1: begin
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b0;
          dfr <= rising ? 1'b1 : 1'b0;
        end
        BELOW_S1: begin
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
          dfr <= 1'b1; // Supplemental valve always on below s1 per problem statement (lowest level)
        end
        default: begin
          // Should never happen, but turn on all flows for safety
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
          dfr <= 1'b1;
        end
      endcase
    end
  end

endmodule