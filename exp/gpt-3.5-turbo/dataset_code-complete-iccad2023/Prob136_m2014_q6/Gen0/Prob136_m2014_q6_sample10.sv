module TopModule (
  input clk,
  input reset,
  input w,
  output reg z
);

// Define states using parameters
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// State and next state registers
reg [2:0] state, next_state;

// State transition logic
always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

// Output logic
always @* begin
  case (state)
    A: begin
      if (w)
        next_state = A;
      else
        next_state = B;
    end
    B: begin
      if (w)
        next_state = D;
      else
        next_state = C;
    end
    C: begin
      if (w)
        next_state = D;
      else
        next_state = E;
    end
    D: begin
      if (w)
        next_state = A;
      else
        next_state = F;
    end
    E: begin
      if (w)
        next_state = D;
      else
        next_state = E;
    end
    F: begin
      if (w)
        next_state = D;
      else
        next_state = C;
    end
    default: next_state = A;
  endcase
end

// Output
assign z = (state == E) ? 1'b1 : 1'b0;

endmodule