module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

// State encoding
parameter A = 3'b001, B = 3'b010, C = 3'b100, D = 3'b000;
reg [2:0] state, next_state;

always @(*) begin
  case(state)
    A: begin
      if (r[1]) begin
        g = {1,0,0};
        next_state = B;
      end else if (r[2]) begin
        g = {0,1,0};
        next_state = C;
      end else if (r[3]) begin
        g = {0,0,1};
        next_state = D;
      end else begin
        g = {0,0,0};
        next_state = A;
      end
    end
    B: begin
      if (r[1]) begin
        g = {1,0,0};
        next_state = B;
      end else begin
        g = {0,0,0};
        next_state = A;
      end
    end
    C: begin
      if (r[2]) begin
        g = {0,1,0};
        next_state = C;
      end else begin
        g = {0,0,0};
        next_state = A;
      end
    end
    D: begin
      if (r[3]) begin
        g = {0,0,1};
        next_state = D;
      end else begin
        g = {0,0,0};
        next_state = A;
      end
    end
  endcase
end

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= A;
  end
  else begin
    state <= next_state;
  end
end

endmodule