module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

  // State encoding
  typedef enum reg [2:0] {
    S0 = 3'd0, // no match
    S1 = 3'd1, // matched '1'
    S2 = 3'd2, // matched '11'
    S3 = 3'd3, // matched '110'
    S4 = 3'd4  // matched '1101' - final state
  } state_t;

  state_t state, next_state;

  // Next state logic
  always @(*) begin
    case(state)
      S0: next_state = data ? S1 : S0;
      S1: next_state = data ? S2 : S0;
      S2: next_state = data ? S2 : S3;
      S3: next_state = data ? S4 : S0;
      S4: next_state = S4; // stay in final state
      default: next_state = S0;
    endcase
  end

  // State register and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      start_shifting <= 1'b0;
    end else begin
      state <= next_state;
      if (state == S4)
        start_shifting <= 1'b1;
    end
  end

endmodule