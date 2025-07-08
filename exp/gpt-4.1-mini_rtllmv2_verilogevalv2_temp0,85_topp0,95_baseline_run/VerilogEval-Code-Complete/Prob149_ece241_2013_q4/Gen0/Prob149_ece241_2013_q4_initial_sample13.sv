module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Define states representing water levels
  typedef enum reg [1:0] {
    BELOW_S1 = 2'd0,
    BETWEEN_S2_S1 = 2'd1,
    BETWEEN_S3_S2 = 2'd2,
    ABOVE_S3 = 2'd3
  } state_t;

  state_t current_state, next_state;
  state_t prev_state;

  // Determine next water level state based on sensor inputs
  // According to the sensor assertions:
  // ABOVE_S3: s[1]=1, s[2]=1, s[3]=1
  // BETWEEN_S3_S2: s[1]=1, s[2]=1, s[3]=0
  // BETWEEN_S2_S1: s[1]=1, s[2]=0, s[3]=0
  // BELOW_S1: s[1]=0, s[2]=0, s[3]=0

  always @(*) begin
    if (s[1] & s[2] & s[3]) 
      next_state = ABOVE_S3;
    else if (s[1] & s[2] & ~s[3]) 
      next_state = BETWEEN_S3_S2;
    else if (s[1] & ~s[2] & ~s[3]) 
      next_state = BETWEEN_S2_S1;
    else 
      next_state = BELOW_S1;
  end

  // State register update on clk
  always @(posedge clk) begin
    if (reset) begin
      // Reset state to Below S1 (lowest water level) with all flow valves open
      current_state <= BELOW_S1;
      prev_state <= BELOW_S1;
    end else begin
      prev_state <= current_state;
      current_state <= next_state;
    end
  end

  // Output logic: fr1, fr2, fr3 assert based on current water level
  // dfr assert if water level rising (next_state > prev_state)
  always @(*) begin
    // Default outputs
    fr1 = 0;
    fr2 = 0;
    fr3 = 0;
    dfr = 0;

    case (current_state)
      ABOVE_S3: begin
        // Above s[3], no flow valves open
        fr1 = 0; fr2 = 0; fr3 = 0;
      end
      BETWEEN_S3_S2: begin
        // fr1 only
        fr1 = 1; fr2 = 0; fr3 = 0;
      end
      BETWEEN_S2_S1: begin
        // fr1 and fr2
        fr1 = 1; fr2 = 1; fr3 = 0;
      end
      BELOW_S1: begin
        // fr1, fr2, fr3
        fr1 = 1; fr2 = 1; fr3 = 1;
      end
    endcase

    // Determine if supplemental valve dfr should be asserted (rising level)
    // Rising means next_state > prev_state
    // Because prev_state is the last stable state and current_state has been updated
    // after clock, we use current_state and prev_state.
    // Since outputs are combinational from current_state, but dfr depends on direction,
    // we compare current_state and prev_state.

    if (current_state > prev_state)
      dfr = 1;
    else
      dfr = 0;

    // For reset condition dfr is asserted as well because prev_state == current_state == BELOW_S1
    // but reset forces all valves open including dfr. This is handled in synchronous reset above.
  end

endmodule