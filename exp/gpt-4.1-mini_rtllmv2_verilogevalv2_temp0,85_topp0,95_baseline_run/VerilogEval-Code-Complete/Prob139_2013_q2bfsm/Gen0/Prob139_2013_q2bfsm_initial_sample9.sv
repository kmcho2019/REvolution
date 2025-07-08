module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  // Define states
  typedef enum logic [3:0] {
    A      = 4'd0,  // reset state
    B      = 4'd1,  // f=1 for one cycle after resetn deassertion
    S1     = 4'd2,  // waiting for x=1 (first in sequence)
    S2     = 4'd3,  // waiting for x=0 (second in sequence)
    S3     = 4'd4,  // waiting for x=1 (third in sequence)
    G_ON_0 = 4'd5,  // g=1, start monitoring y, 0 cycles elapsed
    G_ON_1 = 4'd6,  // g=1, 1 cycle elapsed monitoring y
    G_OFF  = 4'd7   // g=0 permanently until reset
  } state_t;

  state_t state, next_state;

  // Sequential state update
  always @(posedge clk) begin
    if (!resetn)
      state <= A;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case(state)
      A: begin
        if (resetn)
          next_state = B;
        else
          next_state = A;
      end

      B: begin
        // after one cycle with f=1, move to detect x sequence
        next_state = S1;
      end

      S1: begin
        // wait for x=1 to start sequence
        if (x == 1)
          next_state = S2;
        else
          next_state = S1;
      end

      S2: begin
        // wait for x=0 next
        if (x == 0)
          next_state = S3;
        else if (x == 1)
          next_state = S2; // if x=1, stay in S2 since sequence broken, restart
        else
          next_state = S1; // if x!=0 or 1, restart sequence detection (go to S1)
      end

      S3: begin
        // wait for x=1 last in sequence
        if (x == 1)
          next_state = G_ON_0;
        else if (x == 0)
          next_state = S1; // restart sequence detection if no match
        else
          next_state = S1; // restart sequence detection
      end

      G_ON_0: begin
        // g=1, first cycle monitoring y
        if (y == 1)
          next_state = G_ON_1; // permanent g=1 state
        else
          next_state = G_ON_1; // move to second cycle monitoring y
      end

      G_ON_1: begin
        if (y == 1)
          next_state = G_ON_1; // stay permanently with g=1
        else
          next_state = G_OFF;  // did not see y=1 within 2 cycles, g=0 permanently
      end

      G_OFF: begin
        // permanent g=0 until reset
        next_state = G_OFF;
      end

      default: next_state = A;
    endcase
  end

  // Output logic
  always @(*) begin
    f = 0;
    g = 0;
    case(state)
      B: f = 1;
      G_ON_0: g = 1;
      G_ON_1: g = 1;
      default: ;
    endcase
  end

endmodule