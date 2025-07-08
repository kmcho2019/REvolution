module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  typedef enum logic [2:0] {
    S0 = 3'd0, // no consecutive ones
    S1 = 3'd1,
    S2 = 3'd2,
    S3 = 3'd3,
    S4 = 3'd4,
    S5 = 3'd5,
    S6 = 3'd6,
    S7 = 3'd7 // error state (7 or more ones)
  } state_t;

  state_t state, next_state;

  // Output registers for Moore machine
  reg disc_d, flag_d, err_d;

  // State transition logic
  always @(*) begin
    // Default outputs
    disc_d = 1'b0;
    flag_d = 1'b0;
    err_d = 1'b0;
    case (state)
      S0: begin
        if (in)
          next_state = S1;
        else
          next_state = S0;
      end

      S1: begin
        if (in)
          next_state = S2;
        else
          next_state = S0;
      end

      S2: begin
        if (in)
          next_state = S3;
        else
          next_state = S0;
      end

      S3: begin
        if (in)
          next_state = S4;
        else
          next_state = S0;
      end

      S4: begin
        if (in)
          next_state = S5;
        else
          next_state = S0;
      end

      S5: begin
        if (in)
          next_state = S6;
        else begin
          // 5 ones then 0 => discard bit after 5 ones
          disc_d = 1'b1;
          next_state = S0;
        end
      end

      S6: begin
        if (in) begin
          // 7 or more ones => error
          err_d = 1'b1;
          next_state = S7;
        end else begin
          // 6 ones then 0 => flag
          flag_d = 1'b1;
          next_state = S0;
        end
      end

      S7: begin
        // Stay in error state until reset or 0 input resets count
        err_d = 1'b1;
        if (in)
          next_state = S7;
        else
          next_state = S0;
      end

      default: begin
        next_state = S0;
      end
    endcase
  end

  // State and output registers: synchronous logic
  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      disc <= 1'b0;
      flag <= 1'b0;
      err <= 1'b0;
    end else begin
      state <= next_state;
      disc <= disc_d;
      flag <= flag_d;
      err <= err_d;
    end
  end

endmodule