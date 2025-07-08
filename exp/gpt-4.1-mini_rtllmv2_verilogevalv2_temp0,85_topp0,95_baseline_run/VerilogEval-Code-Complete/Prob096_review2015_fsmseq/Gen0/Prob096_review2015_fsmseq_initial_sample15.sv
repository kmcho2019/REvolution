module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

  // State encoding
  typedef enum logic [2:0] {
    S0 = 3'b000, // initial state, no bits matched
    S1 = 3'b001, // matched '1'
    S2 = 3'b010, // matched '11'
    S3 = 3'b011, // matched '110'
    S4 = 3'b100  // matched '1101' (final state)
  } state_t;

  state_t current_state, next_state;

  // Next state logic
  always @(*) begin
    case(current_state)
      S0: next_state = (data) ? S1 : S0;
      S1: next_state = (data) ? S2 : S0;
      S2: next_state = (data) ? S2 : S3;
      S3: next_state = (data) ? S4 : S0;
      S4: next_state = S4; // stay in final state forever
      default: next_state = S0;
    endcase
  end

  // State register and output logic
  always @(posedge clk) begin
    if (reset) begin
      current_state <= S0;
      start_shifting <= 1'b0;
    end else begin
      current_state <= next_state;
      if (current_state == S4)
        start_shifting <= 1'b1;
    end
  end

endmodule