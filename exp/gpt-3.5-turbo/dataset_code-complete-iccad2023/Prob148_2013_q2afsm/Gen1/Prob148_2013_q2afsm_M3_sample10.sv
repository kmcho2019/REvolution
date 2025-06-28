module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output [3:1] g
);

  // State encoding
  localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

  reg [1:0] state, next_state;

  // State flip-flop with synchronous reset
  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end

  // State transition and grant logic
  always @* begin
    case(state)
      A: begin
        if (r[1] && ~r[2] && ~r[3]) next_state = B;
        else if (~r[1] && r[2] && ~r[3]) next_state = C;
        else if (~r[1] && ~r[2] && ~r[3]) next_state = D;
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
        if (r[3]) next_state = D;
        else next_state = A;
      end
    endcase
  end

  // Grant signal assignment based on current state
  assign g[1] = (state == B) ? 1 : 0;
  assign g[2] = (state == C) ? 1 : 0;
  assign g[3] = (state == D) ? 1 : 0;

endmodule