module TopModule (
  input clk,
  input reset,
  input w,
  output reg z
);

// Define states
parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;
reg [2:0] state, next_state;

// State transition logic
always @(*) begin
  case (state)
    A: begin
      next_state = (w) ? A : B;
    end
    B: begin
      next_state = (w) ? D : C;
    end
    C: begin
      next_state = (w) ? D : E;
    end
    D: begin
      next_state = (w) ? A : F;
    end
    E: begin
      next_state = (w) ? D : E;
    end
    F: begin
      next_state = (w) ? D : C;
    end
    default: next_state = 3'b000;
  endcase
end

// State register
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

// Output logic
assign z = (state == E || state == F);

endmodule