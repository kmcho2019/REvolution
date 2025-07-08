module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  typedef enum reg [1:0] {
    BELOW_S1       = 2'd0,
    BETWEEN_S1_S2  = 2'd1,
    BETWEEN_S2_S3  = 2'd2,
    ABOVE_S3       = 2'd3
  } state_t;

  state_t current_state, next_state;
  state_t prev_state;

  // Determine next state based on sensor inputs
  always @(*) begin
    // Sensors:
    // s[1] lowest, s[2] middle, s[3] highest
    // Water level states:
    // ABOVE_S3: s[1], s[2], s[3] all asserted
    // BETWEEN_S2_S3: s[1], s[2] asserted; s[3] deasserted
    // BETWEEN_S1_S2: s[1] asserted; s[2], s[3] deasserted
    // BELOW_S1: none asserted

    if (s[1] && s[2] && s[3]) begin
      next_state = ABOVE_S3;
    end else if (s[1] && s[2] && !s[3]) begin
      next_state = BETWEEN_S2_S3;
    end else if (s[1] && !s[2] && !s[3]) begin
      next_state = BETWEEN_S1_S2;
    end else begin
      // no sensors asserted
      next_state = BELOW_S1;
    end
  end

  // State register and previous state tracking
  always @(posedge clk) begin
    if (reset) begin
      current_state <= BELOW_S1;
      prev_state <= BELOW_S1;
    end else begin
      prev_state <= current_state;
      current_state <= next_state;
    end
  end

  // Output logic
  always @(*) begin
    // Default outputs
    fr1 = 1'b0;
    fr2 = 1'b0;
    fr3 = 1'b0;
    dfr = 1'b0;

    // Determine if water level is rising (next_state > prev_state)
    // Level order: BELOW_S1 (0) < BETWEEN_S1_S2 (1) < BETWEEN_S2_S3 (2) < ABOVE_S3 (3)
    // Rising means next_state > prev_state
    wire rising = (current_state > prev_state);

    case (current_state)
      BELOW_S1: begin
        // Below s[1]: fr1, fr2, fr3 asserted, dfr asserted (initial and max flow)
        fr1 = 1'b1;
        fr2 = 1'b1;
        fr3 = 1'b1;
        dfr = 1'b1;
      end
      BETWEEN_S1_S2: begin
        // Between s[1] and s[2]: fr1, fr2 asserted
        fr1 = 1'b1;
        fr2 = 1'b1;
        fr3 = 1'b0;
        dfr = rising ? 1'b1 : 1'b0;
      end
      BETWEEN_S2_S3: begin
        // Between s[2] and s[3]: fr1 asserted
        fr1 = 1'b1;
        fr2 = 1'b0;
        fr3 = 1'b0;
        dfr = rising ? 1'b1 : 1'b0;
      end
      ABOVE_S3: begin
        // Above s[3]: no flow valves open
        fr1 = 1'b0;
        fr2 = 1'b0;
        fr3 = 1'b0;
        dfr = 1'b0;
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