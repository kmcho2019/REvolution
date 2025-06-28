module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

  // Define states
  parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
  reg [1:0] state, next_state;
  
  // State transition and output logic
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      state <= A;
      out <= 1'b0;
    end else begin
      state <= next_state;
      case (state)
        A: begin
          next_state = (in) ? B : A;
          out <= 1'b0;
        end
        B: begin
          next_state = (in) ? B : C;
          out <= 1'b0;
        end
        C: begin
          next_state = (in) ? D : A;
          out <= 1'b0;
        end
        D: begin
          next_state = (in) ? B : C;
          out <= 1'b1;
        end
        default: next_state = A;
      endcase
    end
  end

endmodule