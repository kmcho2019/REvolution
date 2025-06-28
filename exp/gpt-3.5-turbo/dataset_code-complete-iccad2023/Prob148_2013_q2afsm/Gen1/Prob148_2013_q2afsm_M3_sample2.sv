module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output [3:1] g
);

  // State encoding
  parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
  reg [1:0] state, next_state;

  // State and output assignment
  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= A;
      g <= 3'b000;
    end else begin
      state <= next_state;
      case (state)
        A: begin
          if (r[1]) next_state = B;
          else if (r[2]) next_state = C;
          else if (r[3]) next_state = D;
          else next_state = A;
        end
        B: begin
          if (r[1]) next_state = B;
          else next_state = A;
        end
        C: begin
          if (r[2]) next_state = C;
          else next_state = A;
        end
        D: begin
          if (r[3]) next_state = D;
          else next_state = A;
        end
        default: next_state = A;
      endcase
      // FSM outputs
      g = (state == B) ? 3'b001 : (state == C) ? 3'b010 : (state == D) ? 3'b100 : 3'b000;
    end
  end

endmodule