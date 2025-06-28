module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

  // Define states A, B, and C
  parameter A = 2'b00;
  parameter B = 2'b01;
  parameter C = 2'b10;

  // Define state register and next state
  reg [1:0] state, next_state;

  // State flip-flop
  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end

  // State transitions logic
  always @* begin
    next_state = state;
    case (state)
      A: begin
        if (r[1]) next_state = B;
        else if (r[2]) next_state = C;
      end
      B: begin
        if (r[1]) next_state = B;
        else next_state = A;
      end
      C: begin
        if (r[2]) next_state = C;
        else next_state = A;
      end
    endcase
  end

  // Grant signal assignments based on states and requests
  always @* begin
    case (state)
      A: begin
        g[3:1] = 3'b000;
        if (r[1]) g[1] = 1;
        else if (r[2]) g[2] = 1;
      end
      B: begin
        g[3:1] = 3'b000;
        g[1] = 1;
      end
      C: begin
        g[3:1] = 3'b000;
        g[2] = 1;
      end
    endcase
  end

endmodule