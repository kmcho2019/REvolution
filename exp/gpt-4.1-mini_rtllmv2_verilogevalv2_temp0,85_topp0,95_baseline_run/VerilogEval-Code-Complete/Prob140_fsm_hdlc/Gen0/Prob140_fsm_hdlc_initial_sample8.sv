module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // States encoding: count of consecutive ones after a zero
  typedef enum logic [3:0] {
    S0 = 4'd0,  // zero or no consecutive ones yet
    S1 = 4'd1,
    S2 = 4'd2,
    S3 = 4'd3,
    S4 = 4'd4,
    S5 = 4'd5,  // 5 consecutive ones
    S6 = 4'd6,  // 6 consecutive ones
    S7 = 4'd7   // error state: 7 or more ones
  } state_t;

  state_t state, next_state;

  // Next state logic
  always @(*) begin
    case(state)
      S0: begin
        if(in == 1'b1)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if(in == 1'b1)
          next_state = S2;
        else
          next_state = S0;
      end
      S2: begin
        if(in == 1'b1)
          next_state = S3;
        else
          next_state = S0;
      end
      S3: begin
        if(in == 1'b1)
          next_state = S4;
        else
          next_state = S0;
      end
      S4: begin
        if(in == 1'b1)
          next_state = S5;
        else
          next_state = S0;
      end
      S5: begin
        if(in == 1'b1)
          next_state = S6;
        else
          next_state = S0;
      end
      S6: begin
        if(in == 1'b1)
          next_state = S7; // error: 7 consecutive ones
        else
          next_state = S0;
      end
      S7: begin
        // Remain in error state until reset
        next_state = S7;
      end
      default: next_state = S0;
    endcase
  end

  // State register with synchronous reset
  always @(posedge clk) begin
    if(reset)
      state <= S0;
    else
      state <= next_state;
  end

  // Moore outputs depend on state only
  // outputs asserted one full cycle after condition occurs:
  // disc: after seeing 5 ones followed by a 0 (pattern 0111110)
  // flag: after seeing 6 ones followed by a 0 (pattern 01111110)
  // err: when 7 or more consecutive ones detected

  assign disc = (state == S5) && (in == 1'b0); // detected stuffed zero after five ones
  assign flag = (state == S6) && (in == 1'b0); // detected flag pattern
  assign err  = (state == S7);

endmodule