module TopModule (
  input clk,
  input in,
  input reset,  // synchronous active high reset
  output reg out
);

// Enumeration for states
typedef enum logic [1:0] {
  A, B, C, D
} state_type;

// State registers
reg state_reg, next_state_reg;

// Next state and output logic
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state_reg <= A;
  end else begin
    state_reg <= next_state_reg;
  end
end

always @* begin
  case (state_reg)
    A: begin
      next_state_reg = in ? B : A;
      out = 0;
    end
    B: begin
      next_state_reg = in ? B : C;
      out = 0;
    end
    C: begin
      next_state_reg = in ? D : A;
      out = 0;
    end
    D: begin
      next_state_reg = in ? B : C;
      out = 1;
    end
    default: begin
      next_state_reg = A;
      out = 0;
    end
  endcase
end

endmodule