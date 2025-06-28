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

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= A;
    g <= 3'b000;
  end
  else begin
    case(state)
      A: begin
        if (r[1] == 1) next_state = B;
        else if (r[2] == 1) next_state = C;
        else if (r[3] == 1) next_state = D;
        else next_state = A;
        
        g <= {next_state == B, next_state == C, next_state == D};
      end
      B: begin
        if (r[1] == 1) next_state = B;
        else next_state = A;
        
        g <= {state == B, 0, 0};
      end
      C: begin
        if (r[2] == 1) next_state = C;
        else next_state = A;
        
        g <= {0, state == C, 0};
      end
      D: begin
        next_state = A;
        
        g <= 3'b000;
      end
    endcase
    state <= next_state;
  end
end

endmodule