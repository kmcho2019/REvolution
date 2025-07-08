module ModuleA (
  input x,
  input y,
  output z
);
  assign z = (x ^ y) & x;
endmodule

module ModuleB (
  input x,
  input y,
  output reg z
);
  always @(*) begin
    case ({x,y})
      2'b00: z = 1'b1;
      2'b01: z = 1'b0;
      2'b10: z = 1'b0;
      2'b11: z = 1'b1;
    endcase
  end
endmodule

module TopModule (
  input x,
  input y,
  output z
);
  wire a1_out, a2_out;
  wire b1_out, b2_out;
  wire or_out, and_out;
  
  // Instantiate Module A instances
  ModuleA A1 (.x(x), .y(y), .z(a1_out));
  ModuleA A2 (.x(x), .y(y), .z(a2_out));
  
  // Instantiate Module B instances
  ModuleB B1 (.x(x), .y(y), .z(b1_out));
  ModuleB B2 (.x(x), .y(y), .z(b2_out));
  
  // First OR gate (A1 + B1)
  assign or_out = a1_out | b1_out;
  
  // Second AND gate (A2 & B2)
  assign and_out = a2_out & b2_out;
  
  // Final XOR gate
  assign z = or_out ^ and_out;
endmodule