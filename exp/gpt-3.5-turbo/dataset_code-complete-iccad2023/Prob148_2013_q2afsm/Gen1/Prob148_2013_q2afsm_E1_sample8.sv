module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

// State encoding binary values
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] state, next_state;

always @(*) begin
  case(state)
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
    D: begin
      next_state = A;
    end
    default: next_state = A;
  endcase
end

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= A;
    g <= 3'b000;
  end
  else begin
    state <= next_state;
    case(state)
      B: g <= {1,0,0};
      C: g <= (r[1] == 1) ? {1,0,0} : (r[2] == 1) ? {0,1,0} : {0,0,0};
      default: g <= {0,0,0};
    endcase
  end
end

endmodule