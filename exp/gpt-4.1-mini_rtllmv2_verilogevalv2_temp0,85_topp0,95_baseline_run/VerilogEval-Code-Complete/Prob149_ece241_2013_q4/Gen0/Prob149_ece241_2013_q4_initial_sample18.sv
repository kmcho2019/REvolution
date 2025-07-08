module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Encoding water levels as 2-bit values:
  // 0 = below s[1] (no sensors asserted)
  // 1 = between s[2] and s[1] (only s[1] asserted)
  // 2 = between s[3] and s[2] (s[1], s[2] asserted)
  // 3 = above s[3] (s[1], s[2], s[3] asserted)
  reg [1:0] prev_level, curr_level;

  always @(*) begin
    // Determine current level from sensors
    if (s[1] && s[2] && s[3])
      curr_level = 2'd3; // above s[3]
    else if (s[1] && s[2] && !s[3])
      curr_level = 2'd2; // between s[3] and s[2]
    else if (s[1] && !s[2])
      curr_level = 2'd1; // between s[2] and s[1]
    else
      curr_level = 2'd0; // below s[1]
  end

  always @(posedge clk) begin
    if (reset) begin
      prev_level <= 2'd0;  // reset to lowest level
    end else begin
      prev_level <= curr_level;
    end
  end

  always @(*) begin
    // Default outputs
    fr1 = 1'b0;
    fr2 = 1'b0;
    fr3 = 1'b0;
    dfr = 1'b0;

    case (curr_level)
      2'd3: begin
        // above s[3]
        // no nominal flow valves asserted
        fr1 = 1'b0; fr2 = 1'b0; fr3 = 1'b0;
      end

      2'd2: begin
        // between s[3] and s[2]
        // nominal flow fr1 asserted
        fr1 = 1'b1; fr2 = 1'b0; fr3 = 1'b0;
      end

      2'd1: begin
        // between s[2] and s[1]
        // nominal flow fr1 and fr2 asserted
        fr1 = 1'b1; fr2 = 1'b1; fr3 = 1'b0;
      end

      2'd0: begin
        // below s[1]
        // all nominal flow valves asserted
        fr1 = 1'b1; fr2 = 1'b1; fr3 = 1'b1;
      end
    endcase

    // Supplemental flow valve dfr asserted if previous level was lower than current
    // i.e. if level increased
    if (curr_level > prev_level)
      dfr = 1'b1;
    else
      dfr = 1'b0;

    // On reset state (prev_level==0), all outputs asserted (nominal + supplemental)
    // We handle reset outputs in sequential logic below
  end

  // Override outputs on reset to required initial state
  always @(posedge clk) begin
    if (reset) begin
      fr1 <= 1'b1;
      fr2 <= 1'b1;
      fr3 <= 1'b1;
      dfr <= 1'b1;
    end
  end

endmodule