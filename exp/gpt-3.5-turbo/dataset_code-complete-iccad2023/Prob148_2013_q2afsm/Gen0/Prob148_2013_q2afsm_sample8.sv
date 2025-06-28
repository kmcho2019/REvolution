module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define state register and next state variables
reg [1:0] state, next_state;

// State logic
always @*
begin
  case(state)
    A: begin
      if (r == 3'b001) next_state = B;
      else if (r == 3'b010) next_state = C;
      else if (r == 3'b000) next_state = D;
      else next_state = A;
    end
    B: begin
      if (r == 3'b001) next_state = B;
      else next_state = A;
    end
    C: begin
      if (r == 3'b010) next_state = C;
      else next_state = A;
    end
    D: begin
      if (r == 3'b000) next_state = D;
      else next_state = A;
    end
    default: next_state = A;
  endcase
end

// State flip-flops
always @(posedge clk or negedge resetn)
begin
  if (~resetn) state <= A;
  else state <= next_state;
end

// Output grant signals
always @*
begin
  case(state)
    A: g = 3'b000;
    B: g = 3'b100;
    C: g = 3'b010;
    D: g = 3'b001;
  endcase
end

endmodule