module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Define water level zones as states:
  // 3 = Above s[3]: s[1], s[2], s[3] asserted
  // 2 = Between s[3] and s[2]: s[1], s[2] asserted only
  // 1 = Between s[2] and s[1]: s[1] asserted only
  // 0 = Below s[1]: none asserted

  reg [1:0] curr_level, prev_level;

  // Function to decode sensor inputs to level
  // Level encoding:
  // 3 = s[1]=1, s[2]=1, s[3]=1
  // 2 = s[1]=1, s[2]=1, s[3]=0
  // 1 = s[1]=1, s[2]=0, s[3]=0
  // 0 = s[1]=0, s[2]=0, s[3]=0
  // Any other combination is invalid and treated as below s[1] for safety
  function [1:0] decode_level;
    input [3:1] s_in;
    begin
      if (s_in[1]==1 && s_in[2]==1 && s_in[3]==1)
        decode_level = 2'd3;
      else if (s_in[1]==1 && s_in[2]==1 && s_in[3]==0)
        decode_level = 2'd2;
      else if (s_in[1]==1 && s_in[2]==0 && s_in[3]==0)
        decode_level = 2'd1;
      else
        decode_level = 2'd0;
    end
  endfunction

  always @(posedge clk) begin
    if (reset) begin
      // Reset to low water level for a long time:
      prev_level <= 2'd0;
      curr_level <= 2'd0;
      // Outputs asserted for low water level with dfr asserted
      fr1 <= 1'b1;
      fr2 <= 1'b1;
      fr3 <= 1'b1;
      dfr <= 1'b1;
    end else begin
      curr_level <= decode_level(s);
      prev_level <= curr_level;

      // Determine nominal flow valves based on curr_level
      case (curr_level)
        2'd3: begin // Above s[3]
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
          dfr <= 1'b0; // no flow needed
        end
        2'd2: begin // Between s[3] and s[2]
          fr1 <= 1'b1;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
          // dfr asserted if rising from lower level (prev < curr)
          dfr <= (prev_level < curr_level) ? 1'b1 : 1'b0;
        end
        2'd1: begin // Between s[2] and s[1]
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b0;
          dfr <= (prev_level < curr_level) ? 1'b1 : 1'b0;
        end
        2'd0: begin // Below s[1]
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
          dfr <= 1'b1; // supplemental always open when below lowest
        end
        default: begin
          // Should not happen, treat as below s[1]
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
          dfr <= 1'b1;
        end
      endcase
    end
  end

endmodule