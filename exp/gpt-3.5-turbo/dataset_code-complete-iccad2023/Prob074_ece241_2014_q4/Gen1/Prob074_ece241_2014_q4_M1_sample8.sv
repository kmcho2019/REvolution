module StateModule (
  input clk,
  input x,
  input previous_state,
  output reg current_state,
  output reg z
);
  reg d;
  
  always @(posedge clk) begin
    case (previous_state)
      0: begin
        d = x ^ current_state; // XOR gate
        current_state <= ~current_state; // Next state
      end
      1: begin
        d = x & ~current_state; // AND gate
        current_state <= ~current_state; // Next state
      end
      2: begin
        d = x | ~current_state; // OR gate
        current_state <= ~current_state; // Next state
      end
    endcase
  end
  
  DFlipFlop FF(clk, d, z); // D flip-flop to generate Z
  
endmodule

module DFlipFlop (
  input clk,
  input d,
  output reg q
);
  always @(posedge clk)
    q <= d;
endmodule

module TopModule (
  input clk,
  input x,
  output z
);
  reg state;
  
  StateModule State(clk, x, state, state, z);
endmodule