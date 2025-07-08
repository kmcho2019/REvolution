module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  // States represent count of consecutive 1s since last 0:
  // S0 - zero consecutive 1s (previous input was 0)
  // S1 - one consecutive 1
  // S2 - two consecutive 1s
  // S3 - three consecutive 1s
  // S4 - four consecutive 1s
  // S5 - five consecutive 1s
  // S6 - six consecutive 1s
  // S7 - seven or more consecutive 1s (error)
  typedef enum logic [3:0] {
    S0 = 4'd0,
    S1 = 4'd1,
    S2 = 4'd2,
    S3 = 4'd3,
    S4 = 4'd4,
    S5 = 4'd5,
    S6 = 4'd6,
    S7 = 4'd7
  } state_t;

  state_t state, next_state;

  // Next state logic
  always @(*) begin
    case (state)
      S0: next_state = in ? S1 : S0;
      S1: next_state = in ? S2 : S0;
      S2: next_state = in ? S3 : S0;
      S3: next_state = in ? S4 : S0;
      S4: next_state = in ? S5 : S0;
      S5: next_state = in ? S6 : S0;
      S6: next_state = in ? S7 : S0;
      S7: next_state = in ? S7 : S0; // stay in error if input 1, else reset
      default: next_state = S0;
    endcase
  end

  // Output logic (Moore machine)
  // Outputs asserted for one full clock cycle after detecting the pattern.
  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      disc <= 1'b0;
      flag <= 1'b0;
      err <= 1'b0;
    end else begin
      state <= next_state;

      // Default outputs
      disc <= 1'b0;
      flag <= 1'b0;
      err <= 1'b0;

      // According to Moore FSM, outputs depend only on current state.
      case (state)
        S5: if (~in) disc <= 1'b1;   // 0111110 detected: zero after 5 ones, discard zero
        S6: if (~in) flag <= 1'b1;   // 01111110 detected: flag
        S7: err <= 1'b1;             // 7 or more ones: error
        default: begin
          disc <= 1'b0;
          flag <= 1'b0;
          err <= 1'b0;
        end
      endcase
    end
  end

endmodule