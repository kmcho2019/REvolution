module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  // State encoding
  typedef enum reg [2:0] {
    A = 3'd0,    // Reset state
    B = 3'd1,    // f=1 for one cycle after reset
    C0 = 3'd2,   // Waiting for x=1
    C1 = 3'd3,   // Waiting for x=0
    C2 = 3'd4,   // Waiting for x=1
    D0 = 3'd5,   // g=1, check y at cycle 0
    D1 = 3'd6,   // g=1, check y at cycle 1
    E = 3'd7,    // g=1 permanently (y detected)
    F = 3'd8     // g=0 permanently (y not detected)
  } state_t;

  state_t state, next_state;

  // State register update
  always @(posedge clk) begin
    if (!resetn) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state; // default hold

    case(state)
      A: begin
        if (resetn)
          next_state = B;
        else
          next_state = A;
      end

      B: begin
        // after one cycle with f=1, start monitoring x sequence
        next_state = C0;
      end

      C0: begin
        // Wait for x=1 to start sequence
        if (x == 1'b1)
          next_state = C1;
        else
          next_state = C0;
      end

      C1: begin
        // Wait for x=0 next
        if (x == 1'b0)
          next_state = C2;
        else if (x == 1'b1)
          next_state = C1; // stay waiting for 0, sequence not progressing
        else
          next_state = C1;
      end

      C2: begin
        // Wait for x=1 to complete sequence
        if (x == 1'b1)
          next_state = D0; // sequence matched, set g=1 and check y
        else if (x == 1'b0)
          next_state = C0; // sequence broken, restart from x=1
        else
          next_state = C2;
      end

      D0: begin
        if (y == 1'b1)
          next_state = E; // y detected first cycle, maintain g=1
        else
          next_state = D1; // check next cycle
      end

      D1: begin
        if (y == 1'b1)
          next_state = E; // y detected second cycle, maintain g=1
        else
          next_state = F; // y not detected in 2 cycles, g=0 permanently
      end

      E: begin
        // Maintain g=1 until reset
        next_state = E;
      end

      F: begin
        // Maintain g=0 until reset
        next_state = F;
      end

      default: next_state = A;
    endcase
  end

  // Output logic
  always @(*) begin
    // Default outputs
    f = 1'b0;
    g = 1'b0;

    case(state)
      B: f = 1'b1;        // f=1 for one cycle after reset release
      D0, D1, E: g = 1'b1; // g=1 while monitoring y and permanently if detected
      default: begin
        if (state == F)
          g = 1'b0;       // g=0 permanently
      end
    endcase
  end

endmodule