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
  wire d1, d2, d3;
  reg [2:0] state;
  reg [2:0] next_state;
  
  // Define states
  localparam S0 = 3'b000, S1 = 3'b001, S2 = 3'b010;
  
  // Define D flip-flops
  DFlipFlop FF1(clk, d1, state[0]);
  DFlipFlop FF2(clk, d2, state[1]);
  DFlipFlop FF3(clk, d3, state[2]);
  
  // Connect gates to D flip-flops
  XORGate XOR(x, state[0], d1);
  ANDGate AND(x, ~state[1], d2);
  ORGate OR(x, ~state[2], d3);
  
  // Combinational logic for state transitions
  always @(*)
  begin
    next_state = state;
    case(state)
      S0: begin
        if (x) next_state = S1;
      end
      S1: begin
        if (x) next_state = S2;
        else next_state = S0;
      end
      S2: begin
        if (x) next_state = S2;
        else next_state = S1;
      end
    endcase
  end

  // Output generation based on state
  assign z = ~(state[0] | state[1] | state[2]);

  // State updates
  always @(posedge clk)
    state <= next_state;
    
endmodule