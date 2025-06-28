module A (
  input x,
  input y,
  output reg z
);
  
  always @* begin
    z = (x ^ y) & x;
  end
  
endmodule

module B (
  input x,
  input y,
  output reg z
);
  
  always @* begin
    case ({x, y})
      2'b00: z = 1;
      2'b01: z = 0;
      2'b10: z = 0;
      2'b11: z = 1;
      default: z = 0;
    endcase
  end
  
endmodule

module TopModule (
  input x,
  input y,
  output z
);

  wire a_out, b_out;

  A A_inst1 (.x(x), .y(y), .z(a_out));
  A A_inst2 (.x(x), .y(y), .z(b_out));

  B B_inst1 (.x(x), .y(y), .z(a_out));
  B B_inst2 (.x(x), .y(y), .z(b_out));

  assign z = a_out ^ b_out;

endmodule