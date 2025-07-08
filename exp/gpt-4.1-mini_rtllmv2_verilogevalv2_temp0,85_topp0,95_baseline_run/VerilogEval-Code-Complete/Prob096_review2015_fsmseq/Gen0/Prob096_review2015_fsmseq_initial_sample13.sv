module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

  // State encoding
  typedef enum reg [2:0] {
    S0 = 3'd0,  // No bits matched yet
    S1 = 3'd1,  // matched 1
    S2 = 3'd2,  // matched 11
    S3 = 3'd3,  // matched 110
    S4 = 3'd4   // matched 1101 - detected sequence
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
        else              next_state = S2; // Stay in S2 if another 1 arrives (overlapping sequences)
      end
      S3: begin
        if (data == 1'b1) next_state = S4;  // sequence found
        else              next_state = S0;
      end
      S4: begin
        // Stay here forever once sequence is detected
        next_state = S4;
      end
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
      if (next_state == S4)
        start_shifting <= 1'b1;
      // Once start_shifting is 1, it remains 1 forever until reset
    end
  end

endmodule