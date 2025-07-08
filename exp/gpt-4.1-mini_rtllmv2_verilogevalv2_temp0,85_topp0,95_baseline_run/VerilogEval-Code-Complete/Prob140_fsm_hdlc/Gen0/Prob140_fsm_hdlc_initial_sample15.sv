module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  // State encoding: count of consecutive 1s
  typedef enum logic [3:0] {
    S0 = 4'd0, // no consecutive 1s
    S1 = 4'd1, // 1 consecutive 1
    S2 = 4'd2,
    S3 = 4'd3,
    S4 = 4'd4,
    S5 = 4'd5,
    S6 = 4'd6,
    S7P = 4'd7  // 7 or more consecutive 1s (error state)
  } state_t;

  state_t state, next_state;

  // Next state logic
  always @(*) begin
    case(state)
      S0: begin
        if (in == 1'b1) next_state = S1;
        else next_state = S0;
      end
      S1: begin
        if (in == 1'b1) next_state = S2;
        else next_state = S0;
      end
      S2: begin
        if (in == 1'b1) next_state = S3;
        else next_state = S0;
      end
      S3: begin
        if (in == 1'b1) next_state = S4;
        else next_state = S0;
      end
      S4: begin
        if (in == 1'b1) next_state = S5;
        else next_state = S0;
      end
      S5: begin
        if (in == 1'b1) next_state = S6;
        else next_state = S0;
      end
      S6: begin
        if (in == 1'b1) next_state = S7P;
        else next_state = S0;
      end
      S7P: begin
        // Once error, stay in error or if zero input, go to S0
        if (in == 1'b1) next_state = S7P;
        else next_state = S0;
      end
      default: next_state = S0;
    endcase
  end

  // Output logic (Moore: depends on current state only)
  // Outputs asserted for one cycle on the cycle AFTER the pattern is detected.
  // So outputs depend on the previous state and input, thus implemented as registered signals with one cycle delay.
  reg disc_reg, flag_reg, err_reg;

  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      disc_reg <= 1'b0;
      flag_reg <= 1'b0;
      err_reg <= 1'b0;
    end else begin
      state <= next_state;

      // Default output values
      disc_reg <= 1'b0;
      flag_reg <= 1'b0;
      err_reg <= 1'b0;

      // For disc: previous state was S5, current input zero triggers disc on next cycle
      // For flag: previous state was S6, current input zero triggers flag on next cycle
      // For err: in S7P state, err asserted continuously

      case(state)
        S0, S1, S2, S3, S4: begin
          // no outputs asserted
          disc_reg <= 1'b0;
          flag_reg <= 1'b0;
          err_reg <= 1'b0;
        end
        S5: begin
          if (in == 1'b0) disc_reg <= 1'b1; // disc after 5 ones + 0
        end
        S6: begin
          if (in == 1'b0) flag_reg <= 1'b1; // flag after 6 ones + 0
        end
        S7P: begin
          err_reg <= 1'b1; // error if 7 or more ones
        end
      endcase
    end
  end

  assign disc = disc_reg;
  assign flag = flag_reg;
  assign err = err_reg;

endmodule