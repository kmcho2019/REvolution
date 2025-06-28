module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  // Define states
  reg [2:0] state, next_state;

  // Define state parameters
  parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;

  // State register
  always @(posedge clk or negedge resetn)
    if (!resetn)
      state <= A;
    else
      state <= next_state;

  // Next state logic
  always @(*)
    case(state)
      A: begin
        if (!resetn)
          next_state = A;
        else
          next_state = B;
      end
      B: next_state = (x == 1) ? C : B;
      C: next_state = (x == 0) ? D : C;
      D: next_state = (x == 1) ? E : C;
      E: next_state = (x == 1 && y == 1) ? F : (y == 1) ? E : A;
      F: next_state = F;
    endcase

  // Output logic
  always @(*)
    case(state)
      A: begin
        f = 0;
        g = 0;
      end
      B: begin
        f = 1;
        g = 0;
      end
      C: begin
        f = 0;
        g = 0;
      end
      D: begin
        f = 0;
        g = 0;
      end
      E: begin
        f = 0;
        g = (state == F) ? 1 : 0;
      end
      F: begin
        f = 0;
        g = 1;
      end
    endcase

endmodule