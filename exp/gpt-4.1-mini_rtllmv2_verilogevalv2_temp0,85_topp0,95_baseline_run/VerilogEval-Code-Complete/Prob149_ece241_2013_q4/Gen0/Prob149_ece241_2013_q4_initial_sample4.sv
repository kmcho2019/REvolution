module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

// State encoding for water level (from low to high)
localparam STATE_BELOW_S1       = 2'd0; // no sensors asserted
localparam STATE_BETWEEN_S2_S1  = 2'd1; // only s[1] asserted
localparam STATE_BETWEEN_S3_S2  = 2'd2; // s[1], s[2] asserted
localparam STATE_ABOVE_S3       = 2'd3; // s[1], s[2], s[3] asserted

reg [1:0] current_state, next_state;
reg [1:0] previous_state;

always @(*) begin
  // Determine next state based on sensors
  if (s[1] && s[2] && s[3]) begin
    next_state = STATE_ABOVE_S3;
  end else if (s[1] && s[2] && !s[3]) begin
    next_state = STATE_BETWEEN_S3_S2;
  end else if (s[1] && !s[2]) begin
    next_state = STATE_BETWEEN_S2_S1;
  end else begin
    // no sensors asserted or s[1] not asserted means below s1
    next_state = STATE_BELOW_S1;
  end
end

always @(posedge clk) begin
  if (reset) begin
    // Reset to below s1 with all flow valves and dfr asserted
    current_state <= STATE_BELOW_S1;
    previous_state <= STATE_BELOW_S1;
  end else begin
    previous_state <= current_state;
    current_state <= next_state;
  end
end

wire rising_level = (current_state > previous_state);

// Outputs logic
always @(*) begin
  // Default all outputs zero
  fr1 = 0;
  fr2 = 0;
  fr3 = 0;
  dfr = 0;

  case (current_state)
    STATE_ABOVE_S3: begin
      // No flow valves
      fr1 = 0; fr2 = 0; fr3 = 0;
      dfr = 0;
    end
    STATE_BETWEEN_S3_S2: begin
      // fr1 only
      fr1 = 1;
      fr2 = 0;
      fr3 = 0;
      dfr = rising_level ? 1 : 0;
    end
    STATE_BETWEEN_S2_S1: begin
      // fr1 and fr2
      fr1 = 1;
      fr2 = 1;
      fr3 = 0;
      dfr = rising_level ? 1 : 0;
    end
    STATE_BELOW_S1: begin
      // fr1, fr2, fr3
      fr1 = 1;
      fr2 = 1;
      fr3 = 1;
      dfr = rising_level ? 1 : 0;
    end
    default: begin
      fr1 = 1; fr2 = 1; fr3 = 1; dfr = 1; // safe default matching reset
    end
  endcase
end

endmodule