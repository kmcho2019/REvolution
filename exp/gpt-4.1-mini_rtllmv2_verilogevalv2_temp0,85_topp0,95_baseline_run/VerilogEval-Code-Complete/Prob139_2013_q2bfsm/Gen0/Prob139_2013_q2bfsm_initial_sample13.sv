module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  // FSM states encoding
  typedef enum logic [2:0] {
    A = 3'd0,
    B = 3'd1,
    C0 = 3'd2, // waiting for first x=1
    C1 = 3'd3, // first x=1 detected, waiting for x=0
    C2 = 3'd4, // got x=1,0; waiting for x=1
    D = 3'd5,  // g=1 one clock cycle
    E0 = 3'd6, // monitor y first cycle
    E1 = 3'd7, // monitor y second cycle
    F = 3'd8   // g=0 permanently
  } state_t;

  state_t state, next_state;

  // Synchronous state register
  always @(posedge clk) begin
    if (!resetn)
      state <= A;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    // default next state is current state
    next_state = state;

    case(state)
      A: if (resetn) next_state = B;
      B: next_state = C0;
      // Sequence detection on x: 1,0,1
      C0: next_state = (x==1) ? C1 : C0;
      C1: next_state = (x==0) ? C2 : (x==1 ? C1 : C0);
      C2: next_state = (x==1) ? D : (x==0 ? C0 : C0);
      D: next_state = E0;
      // Monitor y for at most two cycles with g=1
      E0: next_state = (y==1) ? E1 : E1;
      E1: begin
        if (y==1)
          next_state = E1; // remain in E1 permanently with g=1
        else
          next_state = F;  // after two cycles no y=1, g=0 permanently
      end
      F: next_state = F; // remain here until reset
      default: next_state = A;
    endcase
  end

  // Output logic
  always @(posedge clk) begin
    if (!resetn) begin
      f <= 0;
      g <= 0;
    end else begin
      case(state)
        B: f <= 1;
        default: f <= 0;
      endcase

      case(state)
        D: g <= 1;
        E0: g <= 1;
        E1: g <= 1;
        F: g <= 0;
        default: g <= 0;
      endcase
    end
  end

endmodule