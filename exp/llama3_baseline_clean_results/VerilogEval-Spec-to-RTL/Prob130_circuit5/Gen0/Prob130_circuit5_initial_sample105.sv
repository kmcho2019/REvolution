module TopModule(a, b, c, d, e, q);
  input [3:0] a, b, c, d, e;
  output [3:0] q;

  wire [3:0] sel;
  assign sel = c[1:0]; // Only consider lower two bits of c for selection

  always @(*)
    case (sel)
      2'b00: q = b;
      2'b01: q = e;
      2'b10: q = a;
      2'b11: q = d;
      default: q = 4'b1111; // Assign default value for c > 3
    endcase
endmodule