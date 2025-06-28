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

// State transition logic
always @* begin
  case (state)
    A: begin
      if (r[1] == 1) next_state = B;
      else if (r[2] == 1) next_state = C;
      else if (r[3] == 1) next_state = D;
      else next_state = A;
    end
    B: begin
      if (r[1] == 1) next_state = B;
      else next_state = A;
    end
    C: begin
      if (r[2] == 1) next_state = C;
      else next_state = A;
    end
    D: next_state = A;
  endcase
end

// State flip-flop
always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= A;
    g <= 3'b000;
  end else begin
    state <= next_state;
    case (state)
      A: g <= 3'b000;
      B: g <= 3'b100;
      C: g <= 3'b010;
      D: g <= 3'b001;
    endcase
  end
end

endmodule