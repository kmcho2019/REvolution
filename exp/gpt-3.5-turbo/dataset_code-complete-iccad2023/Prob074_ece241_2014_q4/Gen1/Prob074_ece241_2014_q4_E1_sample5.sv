module DFlipFlop (
  input clk,
  input d,
  output reg q
);
  always @(posedge clk)
    q <= d;
endmodule

module ThreeToOneMux (
  input [2:0] select,
  input [2:0] data,
  output reg out
);
  always @*
    case (select)
      3'b000: out = data[0];
      3'b001: out = data[1];
      3'b010: out = data[2];
      default: out = 1'b0; // Default output
    endcase
endmodule

module ThreeInputNORGate (
  input a,
  input b,
  input c,
  output z
);
  assign z = ~(a | b | c);
endmodule

module TopModule (
  input clk,
  input x,
  output z
);
  reg [2:0] select;
  wire d1, d2, d3;
  wire q1, q2, q3;
  
  XORGate XOR1(x, q1, d1);
  ANDGate AND1(x, ~q2, d2);
  ORGate OR1(x, ~q3, d3);
  
  ThreeToOneMux Mux1(select, {d1, d2, d3}, z_in);
  
  DFlipFlop FF1(clk, z_in, q1);
  DFlipFlop FF2(clk, z_in, q2);
  DFlipFlop FF3(clk, z_in, q3);
  
  ThreeInputNORGate NORGate(q1, q2, q3, z);
endmodule