module ShiftRegister (
  input clk,
  input enable,
  input S,
  output reg [7:0] Q
);

reg [7:0] next_Q;

always @(posedge clk) begin
  if (enable) begin
    next_Q[0] <= S;
    next_Q[1] <= Q[0];
    next_Q[2] <= Q[1];
    next_Q[3] <= Q[2];
    next_Q[4] <= Q[3];
    next_Q[5] <= Q[4];
    next_Q[6] <= Q[5];
    next_Q[7] <= Q[6];
  end
end

always @(posedge clk) begin
  if (enable) begin
    Q <= next_Q;
  end
end

endmodule

module Multiplexer (
  input [7:0] Q,
  input A,
  input B,
  input C,
  output reg Z
);

always @(*) begin
  case ({A, B, C})
    3'b000: Z <= Q[0];
    3'b001: Z <= Q[1];
    3'b010: Z <= Q[2];
    3'b011: Z <= Q[3];
    3'b100: Z <= Q[4];
    3'b101: Z <= Q[5];
    3'b110: Z <= Q[6];
    3'b111: Z <= Q[7];
    default: Z <= 0; // Handle default case
  endcase
end

endmodule

module TopModule (
  input clk,
  input enable,
  input S,
  input A,
  input B,
  input C,
  output reg Z
);

reg [7:0] Q;

ShiftRegister SR (.clk(clk), .enable(enable), .S(S), .Q(Q));
Multiplexer MUX (.Q(Q), .A(A), .B(B), .C(C), .Z(Z));

endmodule