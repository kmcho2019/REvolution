module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  // State encoding: number of consecutive 1s seen, from 0 to 6
  // S0: 0 consecutive 1s
  // S1: 1 consecutive 1
  // ...
  // S6: 6 consecutive 1s
  typedef enum reg [2:0] {
    S0 = 3'd0,
    S1 = 3'd1,
    S2 = 3'd2,
    S3 = 3'd3,
    S4 = 3'd4,
    S5 = 3'd5,
    S6 = 3'd6
  } state_t;

  reg [2:0] state, next_state;

  // Signals to indicate conditions detected in current cycle
  reg disc_d, flag_d, err_d;

  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      disc <= 1'b0;
      flag <= 1'b0;
      err <= 1'b0;
      disc_d <= 1'b0;
      flag_d <= 1'b0;
      err_d <= 1'b0;
    end else begin
      state <= next_state;

      // Outputs are asserted based on previous cycle's detection
      disc <= disc_d;
      flag <= flag_d;
      err <= err_d;

      // Clear detection signals; will set again below
      disc_d <= 1'b0;
      flag_d <= 1'b0;
      err_d <= 1'b0;
    end
  end

  // Next state logic and detection signals combinational
  always @(*) begin
    // Default next state is current state
    next_state = state;

    // Default no detection
    disc_d = 1'b0;
    flag_d = 1'b0;
    err_d = 1'b0;

    case(state)
      S0: begin
        if (in == 1'b1)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if (in == 1'b1)
          next_state = S2;
        else
          next_state = S0;
      end
      S2: begin
        if (in == 1'b1)
          next_state = S3;
        else
          next_state = S0;
      end
      S3: begin
        if (in == 1'b1)
          next_state = S4;
        else
          next_state = S0;
      end
      S4: begin
        if (in == 1'b1)
          next_state = S5;
        else
          next_state = S0;
      end
      S5: begin
        if (in == 1'b1) begin
          next_state = S6;
        end else begin
          // 5 consecutive 1s followed by 0 → disc detection
          next_state = S0;
          disc_d = 1'b1;
        end
      end
      S6: begin
        if (in == 1'b1) begin
          // 7 or more consecutive 1s → error detection
          next_state = S6; // stay in error state
          err_d = 1'b1;
        end else begin
          // 6 consecutive 1s followed by 0 → flag detection
          next_state = S0;
          flag_d = 1'b1;
        end
      end
      default: begin
        next_state = S0;
      end
    endcase
  end

endmodule