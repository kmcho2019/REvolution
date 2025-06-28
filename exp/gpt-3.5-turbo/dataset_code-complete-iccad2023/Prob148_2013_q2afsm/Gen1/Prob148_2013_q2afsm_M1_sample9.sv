module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

// State encoding
parameter A = 3'b001;
parameter B = 3'b010;
parameter C = 3'b100;
parameter D = 3'b000;

reg [2:0] state, next_state;

always @(*) begin
  next_state = state;
  case (state)
    A: begin
      next_state = (r[1]) ? B : (r[2]) ? C : (r[3]) ? D : A;
    end
    B: begin
      next_state = (r[1]) ? B : A;
    end
    C: begin
      next_state = (r[2]) ? C : A;
    end
    D: begin
      next_state = A;
    end
  endcase
end

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= A;
    g <= 3'b000;
  end
  else begin
    state <= next_state;
  end
end

always @* begin
  case (state)
    A: g = 3'b000;
    B: g = 3'b100;
    C: g = 3'b010;
    D: g = 3'b001;
  endcase
end

endmodule