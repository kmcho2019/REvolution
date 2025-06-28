module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output [3:1] g
);

  // Define states
  parameter A = 3'b000;
  parameter B = 3'b001;
  parameter C = 3'b010;
  parameter D = 3'b011;

  // Define state register
  reg [3:1] state, next_state;

  // Output grant assignments
  assign g = (state == B) ? 3'b001 :
             (state == C) ? 3'b010 :
             (state == D) ? 3'b100 : 3'b000;

  always @(posedge clk or negedge resetn) begin
      if (~resetn) begin
          state <= A;
      end
      else begin
          case(state)
              A: begin
                  if (r[1] == 1) begin
                      next_state = B;
                  end else if (r[2] == 1) begin
                      next_state = C;
                  end else if (r[3] == 1) begin
                      next_state = D;
                  end
              end
              B: begin
                  if (r[1] == 0) begin
                      next_state = A;
                  end
              end
              C: begin
                  if (r[2] == 0) begin
                      next_state = A;
                  end
              end
              D: begin
                  if (r != 3'b000) begin
                      next_state = D;
                  end else begin
                      next_state = A;
                  end
              end
          endcase
      end
  end

endmodule