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
    S4 = 3'd4  // matched '1101' (detected)
  } state_t;

  state_t state, next_state;

  // Next state logic
  always @(*) begin
    case(state)
      S0: begin
        if (data == 1'b1) next_state = S1;
        else              next_state = S0;
      end
      S1: begin
        if (data == 1'b1) next_state = S2;
        else              next_state = S0;
      end
      S2: begin
        if (data == 1'b0) next_state = S3;
        else              next_state = S2; // data == 1 continues '11' prefix
      end
      S3: begin
        if (data == 1'b1) next_state = S4; // full match 1101 detected
        else              next_state = S0;
      end
      S4: begin
        // Once detected, stay in S4
        next_state = S4;
      end
      default: next_state = S0;
    endcase
  end

  // State register and start_shifting logic
  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      start_shifting <= 1'b0;
    end else begin
      state <= next_state;
      if (next_state == S4)
        start_shifting <= 1'b1;
    end
  end

endmodule