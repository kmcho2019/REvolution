module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  // State encoding
  typedef enum logic [2:0] {
    A = 3'b000,  // reset asserted
    B = 3'b001,  // output f=1 one cycle
    C = 3'b010,  // monitor x for 1,0,1
    D = 3'b011,  // g=1, monitor y for up to 2 cycles
    E = 3'b100,  // g=1 permanently (y=1 detected)
    F = 3'b101   // g=0 permanently (timeout y)
  } state_t;

  state_t state, next_state;

  // For sequence detection of x: keep track of last 3 x samples
  reg [2:0] x_shift;

  // For counting clock cycles in D state for y monitoring
  reg [1:0] y_counter;

  // Next state logic and output logic combined in always block
  always @(posedge clk) begin
    if (~resetn) begin
      // synchronous active low reset
      state <= A;
      f <= 0;
      g <= 0;
      x_shift <= 3'b000;
      y_counter <= 0;
    end else begin
      state <= next_state;

      case (state)
        A: begin
          f <= 0;
          g <= 0;
          x_shift <= 3'b000;
          y_counter <= 0;
        end

        B: begin
          // output f=1 one cycle
          f <= 1;
          g <= 0;
          x_shift <= 3'b000;
          y_counter <= 0;
        end

        C: begin
          f <= 0;
          g <= 0;
          // shift in x
          x_shift <= {x_shift[1:0], x};
          y_counter <= 0;
        end

        D: begin
          f <= 0;
          g <= 1;
          x_shift <= x_shift;
          // increment y_counter only if < 2
          if (y_counter < 2)
            y_counter <= y_counter + 1;
        end

        E: begin
          // g=1 permanently
          f <= 0;
          g <= 1;
          x_shift <= x_shift;
          y_counter <= y_counter;
        end

        F: begin
          // g=0 permanently
          f <= 0;
          g <= 0;
          x_shift <= x_shift;
          y_counter <= y_counter;
        end

        default: begin
          f <= 0;
          g <= 0;
          x_shift <= 3'b000;
          y_counter <= 0;
        end
      endcase
    end
  end

  // Next state combinational logic
  always @(*) begin
    next_state = state;
    case (state)
      A: begin
        // When resetn de-asserted, go to B next clock
        if (resetn)
          next_state = B;
        else
          next_state = A;
      end

      B: begin
        // One cycle with f=1, then go to C
        next_state = C;
      end

      C: begin
        // Shift x in the always block; check if x_shift matches 3-bit pattern 1,0,1
        // x_shift MSB is oldest sample, LSB is newest
        // So pattern is: x_shift == 3'b101
        // But note that we shift in x LSB: x_shift = {x_shift[1:0], x}
        // So after shifting, to detect 1,0,1 in successive clocks, means x_shift==101
        // When detected, move to D
        if (x_shift == 3'b101)
          next_state = D;
        else
          next_state = C;
      end

      D: begin
        // g=1, monitor y for up to 2 cycles
        // If y=1 anytime, go to E (g=1 permanently)
        // If after 2 cycles y!=1, go to F (g=0 permanently)
        if (y == 1)
          next_state = E;
        else if (y_counter == 2)
          next_state = F;
        else
          next_state = D;
      end

      E: begin
        // stay g=1 permanently until reset
        if (~resetn)
          next_state = A;
        else
          next_state = E;
      end

      F: begin
        // stay g=0 permanently until reset
        if (~resetn)
          next_state = A;
        else
          next_state = F;
      end

      default: next_state = A;
    endcase
  end

endmodule