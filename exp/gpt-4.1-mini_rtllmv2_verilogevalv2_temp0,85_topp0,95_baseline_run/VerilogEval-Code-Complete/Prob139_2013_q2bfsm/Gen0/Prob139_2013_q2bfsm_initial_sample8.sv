module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  // State encoding
  typedef enum logic [3:0] {
    A  = 4'd0,  // reset state
    B  = 4'd1,  // f=1 one clock cycle
    C0 = 4'd2,  // waiting for x=1 (first of sequence)
    C1 = 4'd3,  // x=1 detected, waiting for x=0
    C2 = 4'd4,  // x=0 detected, waiting for x=1
    D0 = 4'd5,  // g=1, start monitoring y, 0 cycles counted
    D1 = 4'd6,  // g=1, y=1 detected within 2 cycles, permanent g=1
    D2 = 4'd7,  // g=1, 1 cycle passed waiting for y=1
    D3 = 4'd8   // g=0 permanently until reset
  } state_t;

  state_t state, next_state;

  // Counter for cycles monitoring y (implemented via states D0,D2)
  // f and g outputs are registered.

  // State transition logic
  always @(*) begin
    next_state = state;
    case(state)
      A: begin
        if (resetn) next_state = B; // reset released, move to B
        else next_state = A;
      end

      B: begin
        // After one cycle with f=1, start monitoring x sequence
        next_state = C0;
      end

      C0: begin
        // Waiting for first x=1 of the sequence
        if (x == 1'b1)
          next_state = C1;
        else
          next_state = C0;
      end

      C1: begin
        // x was 1, waiting for x=0
        if (x == 1'b0)
          next_state = C2;
        else if (x == 1'b1)
          next_state = C1; // remain waiting for 0, sequence broken
        else
          next_state = C0; // any other case go back to waiting for first 1
      end

      C2: begin
        // x was 0, waiting for x=1
        if (x == 1'b1)
          next_state = D0;
        else if (x == 1'b0)
          next_state = C2; // keep waiting for last 1
        else
          next_state = C0;
      end

      D0: begin
        // g=1, start monitoring y at cycle 0
        // if y=1 within at most two cycles, go to D1 permanent g=1
        // else after 2 cycles (i.e. on second clock cycle) go to D3 g=0 permanent
        if (y == 1'b1)
          next_state = D1;
        else
          next_state = D2; // move to cycle 1 of wait for y=1
      end

      D2: begin
        // second cycle waiting for y=1
        if (y == 1'b1)
          next_state = D1;
        else
          next_state = D3;
      end

      D1: begin
        // permanent g=1 until reset
        next_state = D1;
      end

      D3: begin
        // permanent g=0 until reset
        next_state = D3;
      end

      default: next_state = A;
    endcase
  end

  // Sequential state update and outputs
  always @(posedge clk) begin
    if (~resetn) begin
      state <= A;
      f <= 1'b0;
      g <= 1'b0;
    end else begin
      state <= next_state;

      // Default outputs
      f <= 1'b0;
      g <= 1'b0;

      case(next_state)
        B: f <= 1'b1;
        D0, D1: g <= 1'b1;
        default: begin
          // f and g already default 0
        end
      endcase
    end
  end

endmodule