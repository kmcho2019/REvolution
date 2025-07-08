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
    A = 3'd0, // reset state, f=0,g=0
    B = 3'd1, // f=1 for one cycle
    C1 = 3'd2, // first x=1 detected
    C2 = 3'd3, // x=0 detected after C1
    C3 = 3'd4, // x=1 detected after C2, ready to set g=1 next cycle
    D = 3'd5, // g=1, monitoring y for max two cycles
    E = 3'd6, // g=1 permanently (y=1 detected)
    F = 3'd7  // g=0 permanently (y not detected within 2 cycles)
  } state_t;

  state_t state, next_state;

  reg [1:0] y_count; // count up to two cycles in state D

  // State register with synchronous active low reset
  always @(posedge clk) begin
    if (!resetn) begin
      state <= A;
      y_count <= 2'd0;
    end else begin
      state <= next_state;
      if (state == D) begin
        y_count <= y_count + 2'd1;
      end else begin
        y_count <= 2'd0;
      end
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case(state)
      A: begin
        // Wait in A while resetn=0, but resetn is synchronous active low, so when resetn=1 go to B
        // Transition from A to B occurs after resetn de-asserted (meaning resetn=1)
        if (resetn)
          next_state = B;
      end

      B: begin
        // After one cycle f=1, start monitoring x sequence
        // If x==1, go to C1, else stay in B waiting for x=1
        if (x == 1'b1)
          next_state = C1;
        else
          next_state = B; 
      end

      C1: begin
        // Expect x=0 next cycle
        if (x == 1'b0)
          next_state = C2;
        else if (!resetn)
          next_state = A;
        else
          next_state = C1; // stay until x=0
      end

      C2: begin
        // Expect x=1 next cycle
        if (x == 1'b1)
          next_state = C3;
        else if (!resetn)
          next_state = A;
        else
          next_state = C2; // stay until x=1
      end

      C3: begin
        // On next cycle, set g=1, go to D
        next_state = D;
      end

      D: begin
        // g=1 while monitoring y for up to 2 cycles
        if (y == 1'b1)
          next_state = E; // maintain g=1 permanently
        else if (y_count >= 2) // after 2 cycles without y=1
          next_state = F; // g=0 permanently
        else
          next_state = D;
      end

      E: begin
        // maintain g=1 permanently until reset
        if (!resetn)
          next_state = A;
        else
          next_state = E;
      end

      F: begin
        // maintain g=0 permanently until reset
        if (!resetn)
          next_state = A;
        else
          next_state = F;
      end

      default: next_state = A;
    endcase
  end

  // Output logic
  always @(*) begin
    f = 1'b0;
    g = 1'b0;
    case(state)
      A: begin
        f = 1'b0;
        g = 1'b0;
      end
      B: begin
        f = 1'b1; // one clock cycle f=1 after reset
        g = 1'b0;
      end
      C1,C2,C3: begin
        f = 1'b0;
        g = 1'b0;
      end
      D: begin
        f = 1'b0;
        g = 1'b1;
      end
      E: begin
        f = 1'b0;
        g = 1'b1;
      end
      F: begin
        f = 1'b0;
        g = 1'b0;
      end
      default: begin
        f = 1'b0;
        g = 1'b0;
      end
    endcase
  end

endmodule