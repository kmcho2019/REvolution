module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

  // States encoded in one-hot style or binary
  typedef enum reg [2:0] {
    S0 = 3'd0, // no match yet
    S1 = 3'd1, // matched '1'
    S2 = 3'd2, // matched '11'
    S3 = 3'd3, // matched '110'
    S4 = 3'd4  // matched '1101' - sequence found, start shifting
  } state_t;

  state_t state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      start_shifting <= 0;
    end else begin
      state <= next_state;
      if (state == S4)
        start_shifting <= 1;
      else if (next_state == S4)
        start_shifting <= 1;
    end
  end

  always @(*) begin
    case(state)
      S0: begin
        if (data == 1)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if (data == 1)
          next_state = S2;
        else
          next_state = S0;
      end
      S2: begin
        if (data == 0)
          next_state = S3;
        else
          next_state = S2;  // stay in S2 if data=1 (sequence 111..)
      end
      S3: begin
        if (data == 1)
          next_state = S4;
        else
          next_state = S0;
      end
      S4: begin
        // stay in S4 forever after sequence found
        next_state = S4;
      end
      default: next_state = S0;
    endcase
  end

endmodule