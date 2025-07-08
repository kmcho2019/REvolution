module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  typedef enum logic [2:0] {
    A = 3'd0,
    B = 3'd1,
    C0 = 3'd2,
    C1 = 3'd3,
    C2 = 3'd4,
    D0 = 3'd5,
    D1 = 3'd6,
    D2 = 3'd7,
    E = 3'd0  // reuse A's encoding since E is a terminal state with different output
  } state_t;

  // To distinguish E from A, we use a separate flag
  // Or better: assign E a unique state value outside 3 bits. Let's expand to 4 bits.
  typedef enum logic [3:0] {
    ST_A = 4'd0,
    ST_B = 4'd1,
    ST_C0 = 4'd2,
    ST_C1 = 4'd3,
    ST_C2 = 4'd4,
    ST_D0 = 4'd5,
    ST_D1 = 4'd6,
    ST_D2 = 4'd7,
    ST_E = 4'd8
  } state_t;

  state_t state, next_state;

  // Sequential state transition
  always @(posedge clk) begin
    if (~resetn) begin
      state <= ST_A;
    end else begin
      state <= next_state;
    end
  end

  // Next state logic and output logic
  always @(*) begin
    // Default values
    f = 1'b0;
    g = 1'b0;
    next_state = state;

    case(state)
      ST_A: begin
        // reset active (or just after reset)
        // outputs f=0 g=0
        if (resetn) begin
          // reset deasserted, go to B
          next_state = ST_B;
        end else begin
          next_state = ST_A;
        end
      end

      ST_B: begin
        // f=1 for one clock cycle after resetn deasserted
        f = 1'b1;
        g = 1'b0;
        next_state = ST_C0;
      end

      // Monitor x for sequence 1,0,1 in successive clocks
      ST_C0: begin
        // waiting for first 1 in x
        f = 1'b0; g = 1'b0;
        if (x == 1'b1)
          next_state = ST_C1;
        else
          next_state = ST_C0;
      end

      ST_C1: begin
        // waiting for 0 in x next clock
        f = 1'b0; g = 1'b0;
        if (x == 1'b0)
          next_state = ST_C2;
        else if (x == 1'b1)
          next_state = ST_C1; // still waiting for 0, ignore repeated 1s (wait for 0)
        else
          next_state = ST_C0; // if x unknown, restart sequence detection
      end

      ST_C2: begin
        // waiting for 1 in x next clock
        f = 1'b0; g = 1'b0;
        if (x == 1'b1)
          next_state = ST_D0; // sequence detected, set g=1 next state
        else if (x == 1'b0)
          next_state = ST_C0; // restart sequence detection
        else
          next_state = ST_C0;
      end

      // After sequence detected, g=1 and monitor y for max 2 cycles
      ST_D0: begin
        f = 1'b0; g = 1'b1;
        if (y == 1'b1)
          next_state = ST_D2; // y detected, permanent g=1
        else
          next_state = ST_D1; // wait one more cycle
      end

      ST_D1: begin
        f = 1'b0; g = 1'b1;
        if (y == 1'b1)
          next_state = ST_D2; // y detected, permanent g=1
        else
          next_state = ST_E;  // y not detected in 2 cycles, g=0 permanent
      end

      ST_D2: begin
        // permanent g=1 until reset
        f = 1'b0; g = 1'b1;
        next_state = ST_D2;
      end

      ST_E: begin
        // permanent g=0 until reset
        f = 1'b0; g = 1'b0;
        next_state = ST_E;
      end

      default: begin
        // should not happen, go to reset state
        f = 1'b0; g = 1'b0;
        next_state = ST_A;
      end
    endcase
  end

endmodule