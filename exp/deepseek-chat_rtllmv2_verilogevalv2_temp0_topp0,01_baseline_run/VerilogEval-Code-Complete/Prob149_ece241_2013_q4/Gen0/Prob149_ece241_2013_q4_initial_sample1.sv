module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Define states
  typedef enum logic [1:0] {
    BELOW_S1,
    BETWEEN_S2_S1,
    BETWEEN_S3_S2,
    ABOVE_S3
  } state_t;

  reg [1:0] current_state, next_state;
  reg was_lower; // Flag to indicate if previous transition was from lower level

  // State transition logic
  always @(*) begin
    case (current_state)
      BELOW_S1: begin
        if (s[1]) next_state = BETWEEN_S2_S1;
        else next_state = BELOW_S1;
      end
      BETWEEN_S2_S1: begin
        if (s[2]) next_state = BETWEEN_S3_S2;
        else if (!s[1]) next_state = BELOW_S1;
        else next_state = BETWEEN_S2_S1;
      end
      BETWEEN_S3_S2: begin
        if (s[3]) next_state = ABOVE_S3;
        else if (!s[2]) next_state = BETWEEN_S2_S1;
        else next_state = BETWEEN_S3_S2;
      end
      ABOVE_S3: begin
        if (!s[3]) next_state = BETWEEN_S3_S2;
        else next_state = ABOVE_S3;
      end
      default: next_state = BELOW_S1;
    endcase
  end

  // Determine if transition was from lower level
  always @(*) begin
    was_lower = 0;
    case (current_state)
      BETWEEN_S2_S1: if (next_state == BETWEEN_S3_S2) was_lower = 1;
      BETWEEN_S3_S2: if (next_state == ABOVE_S3) was_lower = 1;
      BELOW_S1: if (next_state == BETWEEN_S2_S1) was_lower = 1;
    endcase
  end

  // Output logic
  always @(*) begin
    fr3 = 0;
    fr2 = 0;
    fr1 = 0;
    dfr = 0;
    
    case (current_state)
      BELOW_S1: begin
        fr3 = 1;
        fr2 = 1;
        fr1 = 1;
        dfr = 1;
      end
      BETWEEN_S2_S1: begin
        fr1 = 1;
        fr2 = 1;
        dfr = was_lower;
      end
      BETWEEN_S3_S2: begin
        fr1 = 1;
        dfr = was_lower;
      end
      ABOVE_S3: begin
        // All outputs remain 0
      end
    endcase
  end

  // State register
  always @(posedge clk) begin
    if (reset) begin
      current_state <= BELOW_S1;
    end else begin
      current_state <= next_state;
    end
  end

endmodule