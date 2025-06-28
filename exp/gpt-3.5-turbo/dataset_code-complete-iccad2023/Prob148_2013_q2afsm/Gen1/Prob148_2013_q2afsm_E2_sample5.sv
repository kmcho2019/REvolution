module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output [3:1] g
);

  // Define states
  parameter A = 2'b00;
  parameter B = 2'b01;
  parameter C = 2'b10;
  parameter D = 2'b11;

  // State and next state registers
  reg [1:0] state, next_state;

  // Output grant signals
  reg [3:1] g;

  // State flip-flop
  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end

  // State transition logic
  always @(*) begin
    case(state)
      A: begin
        if (r[1] && ~r[2] && ~r[3]) next_state = B;
        else if (~r[1] && r[2] && ~r[3]) next_state = C;
        else if (~r[1] && ~r[2] && r[3]) next_state = D;
        else next_state = A;
      end
      B: begin
        if (r[1]) next_state = B;
        else next_state = A;
      end
      C: begin
        if (r[2]) next_state = C;
        else next_state = A;
      end
      D: begin
        if (r[1]) next_state = D;
        else if (r[2]) next_state = D;
        else if (r[3]) next_state = D;
        else next_state = A;
      end
      default: next_state = A;
    endcase
  end

  // Output grant assignment
  assign g[1] = (state == B || state == D);
  assign g[2] = (state == C || state == D);
  assign g[3] = (state == D);

endmodule