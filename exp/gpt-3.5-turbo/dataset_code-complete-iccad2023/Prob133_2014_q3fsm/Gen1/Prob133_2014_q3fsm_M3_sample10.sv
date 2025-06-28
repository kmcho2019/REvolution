module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);
  
  // Define states
  reg [1:0] state, next_state;
  parameter A = 2'b00;
  parameter B = 2'b01;
  
  // State and output logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= A;
      z <= 0;
    end else begin
      case (state)
        A: begin
          if (s) begin
            next_state = B;
          end else begin
            next_state = A;
          end
        end
        B: begin
          if (w) begin
            next_state = B;
          end else begin
            next_state = A;
          end
          if (state == B && w == 1) begin
            z <= 1;
          end else begin
            z <= 0;
          end
        end
        default: next_state = A;
      endcase
    end
  end
endmodule