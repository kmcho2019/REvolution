module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

  // State encoding
  typedef enum reg [2:0] {
    S0, // no match yet
    S1, // matched '1'
    S11, // matched '11'
    S110, // matched '110'
    S_FOUND // matched '1101', latch start_shifting=1
  } state_t;

  state_t state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      start_shifting <= 1'b0;
    end else begin
      state <= next_state;
      // start_shifting set when in S_FOUND and never cleared except on reset
      if (state == S_FOUND)
        start_shifting <= 1'b1;
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      S0: begin
        if (data == 1'b1)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if (data == 1'b1)
          next_state = S11;
        else
          next_state = S0;
      end
      S11: begin
        if (data == 1'b0)
          next_state = S110;
        else
          next_state = S11; // input 1 after '11', still matched '11'
      end
      S110: begin
        if (data == 1'b1)
          next_state = S_FOUND;
        else if (data == 1'b0)
          next_state = S0; // restart
        else
          next_state = S0;
      end
      S_FOUND: begin
        // Remain here forever until reset
        next_state = S_FOUND;
      end
      default: next_state = S0;
    endcase
  end

endmodule