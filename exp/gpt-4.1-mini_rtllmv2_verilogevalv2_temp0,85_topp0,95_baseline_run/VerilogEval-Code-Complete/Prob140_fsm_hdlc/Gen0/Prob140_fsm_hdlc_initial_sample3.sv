module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // State encoding
  typedef enum reg [3:0] {
    S0 = 4'd0,  // 0 consecutive ones
    S1 = 4'd1,
    S2 = 4'd2,
    S3 = 4'd3,
    S4 = 4'd4,
    S5 = 4'd5,
    S6 = 4'd6,
    S7 = 4'd7   // error state: 7 or more ones
  } state_t;

  reg [3:0] state, next_state;

  // Outputs - Moore outputs depend on state only
  // disc: asserted when the last input was 0 after 5 ones (i.e., transition from S5 with input=0)
  // flag: asserted when the last input was 0 after 6 ones (i.e., transition from S6 with input=0)
  // err: asserted whenever in S7

  reg disc_reg, flag_reg, err_reg;

  assign disc = disc_reg;
  assign flag = flag_reg;
  assign err = err_reg;

  // Next state logic
  always @(*) begin
    case(state)
      S0: begin
        if (in == 1'b1) next_state = S1;
        else            next_state = S0;
      end
      S1: begin
        if (in == 1'b1) next_state = S2;
        else            next_state = S0;
      end
      S2: begin
        if (in == 1'b1) next_state = S3;
        else            next_state = S0;
      end
      S3: begin
        if (in == 1'b1) next_state = S4;
        else            next_state = S0;
      end
      S4: begin
        if (in == 1'b1) next_state = S5;
        else            next_state = S0;
      end
      S5: begin
        if (in == 1'b1) next_state = S6;
        else            next_state = S0;
      end
      S6: begin
        if (in == 1'b1) next_state = S7;
        else            next_state = S0;
      end
      S7: begin
        // Remain in error state on any input
        next_state = S7;
      end
      default: next_state = S0;
    endcase
  end

  // Output logic and state register update
  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      disc_reg <= 1'b0;
      flag_reg <= 1'b0;
      err_reg <= 1'b0;
    end else begin
      // Update state
      state <= next_state;

      // Update outputs based on current state and input (Moore output, outputs valid next cycle)
      // We assert outputs one cycle after the condition occurs, so outputs depend on previous state and input.
      // To implement this, we can generate outputs here based on previous state and input.

      // For disc: condition is previous state = S5 and input=0
      // For flag: condition is previous state = S6 and input=0
      // For err: condition is state = S7 (stays asserted)

      disc_reg <= (state == S5 && in == 1'b0);
      flag_reg <= (state == S6 && in == 1'b0);
      err_reg  <= (state == S7);
    end
  end

endmodule