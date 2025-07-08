module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  // State encoding: number of consecutive 1s after a 0:
  // S0: 0 consecutive 1s (or after a 0)
  // S1..S5: 1..5 consecutive 1s
  // S6: 6 consecutive 1s
  // DISC: Output disc next cycle (detected 5 ones + 0)
  // FLAG: Output flag next cycle (detected 6 ones + 0)
  // ERR: Output err next cycle (7 or more ones)
  typedef enum reg [3:0] {
    S0   = 4'd0,
    S1   = 4'd1,
    S2   = 4'd2,
    S3   = 4'd3,
    S4   = 4'd4,
    S5   = 4'd5,
    S6   = 4'd6,
    DISC = 4'd7,
    FLAG = 4'd8,
    ERR  = 4'd9
  } state_t;

  state_t state, next_state;

  // Next state logic
  always @(*) begin
    case (state)
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
        if (in == 1'b1)
          next_state = S6;
        else
          next_state = DISC; // 5 ones + 0 detected -> disc output next cycle
      end

      S6: begin
        if (in == 1'b1)
          next_state = ERR; // 7 ones detected -> err output next cycle
        else
          next_state = FLAG; // 6 ones + 0 detected -> flag output next cycle
      end

      DISC: begin
        // After disc output, process current input as new start (like S0)
        if (in == 1'b1)
          next_state = S1;
        else
          next_state = S0;
      end

      FLAG: begin
        // After flag output, process current input as new start
        if (in == 1'b1)
          next_state = S1;
        else
          next_state = S0;
      end

      ERR: begin
        // Stay in ERR if input is 1 (still error)
        // Reset count only when input is 0
        if (in == 1'b1)
          next_state = ERR;
        else
          next_state = S0;
      end

      default: next_state = S0;
    endcase
  end

  // State register with synchronous reset
  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
    end else begin
      state <= next_state;
    end
  end

  // Output logic (Moore FSM): outputs asserted for one cycle starting the cycle after detection
  always @(*) begin
    disc = 1'b0;
    flag = 1'b0;
    err  = 1'b0;

    case (state)
      DISC: disc = 1'b1;
      FLAG: flag = 1'b1;
      ERR:  err  = 1'b1;
      default: ;
    endcase
  end

endmodule