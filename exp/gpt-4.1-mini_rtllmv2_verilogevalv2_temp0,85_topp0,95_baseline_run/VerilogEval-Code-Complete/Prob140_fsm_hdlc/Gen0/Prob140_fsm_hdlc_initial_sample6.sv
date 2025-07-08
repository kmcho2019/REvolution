module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);
  // State encoding: number of consecutive 1s after a 0
  typedef enum reg [2:0] {
    S0 = 3'd0, // no consecutive 1s (last bit was 0)
    S1 = 3'd1,
    S2 = 3'd2,
    S3 = 3'd3,
    S4 = 3'd4,
    S5 = 3'd5,
    S6 = 3'd6  // six consecutive 1s
  } state_t;
  
  state_t state, next_state;
  
  // Combinational next state logic
  always @(*) begin
    case(state)
      S0: next_state = (in) ? S1 : S0;
      S1: next_state = (in) ? S2 : S0;
      S2: next_state = (in) ? S3 : S0;
      S3: next_state = (in) ? S4 : S0;
      S4: next_state = (in) ? S5 : S0;
      S5: next_state = (in) ? S6 : S0;
      S6: next_state = (in) ? S6 : S0;
      default: next_state = S0;
    endcase
  end
  
  // Registered state and outputs
  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      disc <= 1'b0;
      flag <= 1'b0;
      err <= 1'b0;
    end else begin
      state <= next_state;
      
      // Default outputs off
      disc <= 1'b0;
      flag <= 1'b0;
      err <= 1'b0;
      
      // Outputs asserted for one cycle starting on cycle after condition detected
      case(state)
        S5: if (~in) disc <= 1'b1;         // 0111110 detected (discard zero)
        S6: if (~in) flag <= 1'b1;         // 01111110 detected (flag)
        S6: if (in)  err <= 1'b1;          // 01111111... detected (error)
      endcase
    end
  end
  
endmodule