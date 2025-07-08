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
  // 3 = above s[3] (s[3]=1)
  // 2 = between s[3] and s[2] (s[3]=0, s[2]=1)
  // 1 = between s[2] and s[1] (s[2]=0, s[1]=1)
  // 0 = below s[1] (s[1]=0)

  reg [1:0] current_level;
  reg [1:0] prev_level;

  always @(posedge clk) begin
    if (reset) begin
      // On reset: below s[1], all outputs asserted
      current_level <= 2'd0;
      prev_level <= 2'd0;
      fr1 <= 1'b1;
      fr2 <= 1'b1;
      fr3 <= 1'b1;
      dfr <= 1'b1;
    end else begin
      // Determine current level from sensors
      if (s[3]) begin
        current_level <= 2'd3; // above s[3]
      end else if (s[2]) begin
        current_level <= 2'd2; // between s[3] and s[2]
      end else if (s[1]) begin
        current_level <= 2'd1; // between s[2] and s[1]
      end else begin
        current_level <= 2'd0; // below s[1]
      end

      // Outputs set based on current level and previous level

      // dfr is set if previous level < current level (water rising)
      dfr <= (prev_level < current_level) ? 1'b1 : 1'b0;

      case (current_level)
        2'd3: begin
          // Above s[3]: no flow valves
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end
        2'd2: begin
          // Between s[3] and s[2]
          fr1 <= 1'b1;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end
        2'd1: begin
          // Between s[2] and s[1]
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b0;
        end
        2'd0: begin
          // Below s[1]
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
        end
        default: begin
          // Default to low flow valves and dfr off
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
          dfr <= 1'b0;
        end
      endcase

      prev_level <= current_level;
    end
  end

endmodule