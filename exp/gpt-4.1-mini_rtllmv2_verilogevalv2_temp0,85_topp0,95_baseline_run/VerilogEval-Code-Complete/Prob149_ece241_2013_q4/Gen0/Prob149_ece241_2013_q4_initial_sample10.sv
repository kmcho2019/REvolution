module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Water level encoding:
  // 2'b00 = Below s[1] (no sensors asserted)
  // 2'b01 = Between s[2] and s[1] (only s[1] asserted)
  // 2'b10 = Between s[3] and s[2] (s[1] and s[2] asserted)
  // 2'b11 = Above s[3] (all s[1], s[2], s[3] asserted)
  reg [1:0] curr_level, prev_level;

  // Function to encode sensor inputs into water level
  function [1:0] encode_level(input [3:1] sensors);
    begin
      if (sensors == 3'b111)        encode_level = 2'b11; // Above s[3]
      else if (sensors[3:2] == 2'b11 && sensors[1] == 1'b0) encode_level = 2'b10; // Between s3 and s2 - Actually invalid as s[1] must be asserted for this level, so we match the problem's definitions carefully
      else if (sensors == 3'b110) encode_level = 2'b10; // s[1]=0,s[2]=1,s[3]=1 not valid per spec, so use 3'b110 means s1=0,s2=1,s3=1? Sensors indexing 3:1 means s3 is bit 3, s1 bit 1.
      // To clarify: the problem states:
      // Above s[3]: s1,s2,s3 asserted (3'b111)
      // Between s[3] and s[2]: s1,s2 asserted (3'b011)
      // Between s[2] and s[1]: s1 asserted (3'b001)
      // Below s[1]: none asserted (3'b000)
      // So we must match this mapping:
      if (sensors == 3'b111) encode_level = 2'b11;      // Above s3
      else if (sensors == 3'b011) encode_level = 2'b10; // Between s3 and s2
      else if (sensors == 3'b001) encode_level = 2'b01; // Between s2 and s1
      else if (sensors == 3'b000) encode_level = 2'b00; // Below s1
      else begin
        // For any other pattern, treat conservatively as below s1
        encode_level = 2'b00;
      end
    end
  endfunction

  wire [1:0] next_level = encode_level(s);

  // Detect if level is rising: current level > previous level (numerically)
  wire level_rising = (next_level > prev_level);

  always @(posedge clk) begin
    if (reset) begin
      // Reset state: low water level for a long time
      prev_level <= 2'b00;
      curr_level <= 2'b00;
      // All flow valves asserted at reset (max flow)
      fr1 <= 1'b1;
      fr2 <= 1'b1;
      fr3 <= 1'b1;
      dfr <= 1'b1;
    end else begin
      prev_level <= curr_level;
      curr_level <= next_level;

      case (next_level)
        2'b11: begin
          // Above s3: no flow valves opened
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
          dfr <= 1'b0;
        end
        2'b10: begin
          // Between s3 and s2: fr1 only
          fr1 <= 1'b1;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
          dfr <= level_rising ? 1'b1 : 1'b0;
        end
        2'b01: begin
          // Between s2 and s1: fr1 and fr2
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b0;
          dfr <= level_rising ? 1'b1 : 1'b0;
        end
        2'b00: begin
          // Below s1: fr1, fr2, fr3 all on
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
          dfr <= 1'b1; // Supplemental flow always on at lowest level
        end
        default: begin
          // Defensive fallback, treat as below s1
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
          dfr <= 1'b1;
        end
      endcase
    end
  end

endmodule