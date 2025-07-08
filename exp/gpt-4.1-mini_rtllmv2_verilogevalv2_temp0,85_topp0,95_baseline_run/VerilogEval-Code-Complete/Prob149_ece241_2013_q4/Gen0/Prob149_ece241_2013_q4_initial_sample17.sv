module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Define water levels as states
  typedef enum reg [1:0] {
    BELOW_S1 = 2'd0,
    BETWEEN_S2_S1 = 2'd1,
    BETWEEN_S3_S2 = 2'd2,
    ABOVE_S3 = 2'd3
  } water_level_t;

  water_level_t current_level, prev_level;

  // Determine current water level from sensor inputs
  function water_level_t get_level(input [3:1] s);
    begin
      if (s[3] && s[2] && s[1])
        get_level = ABOVE_S3;
      else if (s[2] && s[1] && !s[3])
        get_level = BETWEEN_S3_S2;
      else if (s[1] && !s[2] && !s[3])
        get_level = BETWEEN_S2_S1;
      else // none asserted or other cases treated as below s1
        get_level = BELOW_S1;
    end
  endfunction

  // On reset, initialize to BELOW_S1 with all flow rates asserted
  // On each clock, update current_level and prev_level
  always @(posedge clk) begin
    if (reset) begin
      current_level <= BELOW_S1;
      prev_level <= BELOW_S1;
      // outputs assigned in combinational block below
    end else begin
      prev_level <= current_level;
      current_level <= get_level(s);
    end
  end

  // Assign outputs combinationally based on current_level and whether water level rose
  always @(*) begin
    // default outputs
    fr1 = 1'b0;
    fr2 = 1'b0;
    fr3 = 1'b0;
    dfr = 1'b0;

    // Determine if water level increased compared to previous
    // level order: BELOW_S1(0) < BETWEEN_S2_S1(1) < BETWEEN_S3_S2(2) < ABOVE_S3(3)
    // rising if current_level > prev_level
    wire rising = (current_level > prev_level);

    case (current_level)
      ABOVE_S3: begin
        // Above s[3]: input flow rate zero
        // no valves opened
        fr1 = 1'b0;
        fr2 = 1'b0;
        fr3 = 1'b0;
        dfr = 1'b0;
      end
      BETWEEN_S3_S2: begin
        // between s[3] and s[2]: fr1 open nominally
        fr1 = 1'b1;
        fr2 = 1'b0;
        fr3 = 1'b0;
        dfr = rising ? 1'b1 : 1'b0;
      end
      BETWEEN_S2_S1: begin
        // between s[2] and s[1]: fr1 and fr2 nominally
        fr1 = 1'b1;
        fr2 = 1'b1;
        fr3 = 1'b0;
        dfr = rising ? 1'b1 : 1'b0;
      end
      BELOW_S1: begin
        // below s[1]: all flow rates nominally
        fr1 = 1'b1;
        fr2 = 1'b1;
        fr3 = 1'b1;
        dfr = rising ? 1'b1 : 1'b0;
      end
      default: begin
        fr1 = 1'b0;
        fr2 = 1'b0;
        fr3 = 1'b0;
        dfr = 1'b0;
      end
    endcase
  end

endmodule