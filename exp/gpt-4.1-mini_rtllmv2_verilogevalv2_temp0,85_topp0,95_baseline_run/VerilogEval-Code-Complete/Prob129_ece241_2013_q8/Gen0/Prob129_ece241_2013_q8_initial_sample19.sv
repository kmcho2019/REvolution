module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  // State encoding
  typedef enum reg [1:0] {
    S0 = 2'b00,
    S1 = 2'b01,
    S2 = 2'b10
  } state_t;

  state_t state, next_state;

  // Asynchronous negative edge reset and state transition
  always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
      state <= S0;
      z <= 1'b0;
    end else begin
      state <= next_state;
      // z is combinational output from current state and input, so assign here to make Mealy output
      case(state)
        S0: z <= 1'b0;
        S1: z <= 1'b0;
        S2: z <= (x == 1'b1) ? 1'b1 : 1'b0; // when in S2 and input x=1, sequence "101" detected
        default: z <= 1'b0;
      endcase
    end
  end

  // Next state logic (combinational)
  always @(*) begin
    case (state)
      S0: begin
        if (x == 1'b1)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if (x == 1'b0)
          next_state = S2;
        else
          next_state = S1; // stay in S1 if input still '1'
      end
      S2: begin
        if (x == 1'b1)
          next_state = S1;
        else
          next_state = S0;
      end
      default: next_state = S0;
    endcase
  end

endmodule