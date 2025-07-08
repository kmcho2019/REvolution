module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

  // State encoding
  typedef enum logic [2:0] {
    S0 = 3'd0, // no match
    S1 = 3'd1, // matched '1'
    S2 = 3'd2, // matched '11'
    S3 = 3'd3, // matched '110'
    S4 = 3'd4  // matched '1101'
  } state_t;

  state_t state, next_state;

  // Next state logic
  always @(*) begin
    case(state)
      S0: next_state = (data == 1'b1) ? S1 : S0;
      S1: next_state = (data == 1'b1) ? S2 : S0;
      S2: next_state = (data == 1'b0) ? S3 : S2;
      S3: next_state = (data == 1'b1) ? S4 : S0;
      S4: next_state = S4; // latch once sequence found
      default: next_state = S0;
    endcase
  end

  // State register and start_shifting output
  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      start_shifting <= 1'b0;
    end else begin
      state <= next_state;
      if (state == S4)
        start_shifting <= 1'b1;
      else if (start_shifting)
        start_shifting <= 1'b1; // latch once set
      else
        start_shifting <= 1'b0;
    end
  end

endmodule