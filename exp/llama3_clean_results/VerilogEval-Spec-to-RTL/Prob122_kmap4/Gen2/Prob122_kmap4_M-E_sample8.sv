module TopModule(a, b, c, d, out);
  input a;
  input b;
  input c;
  input d;
  output out;

  reg [3:0] index;
  reg out_reg;

  always @(a, b, c, d) begin
    index = {a, b, c, d};
    case (index)
      4'b0000: out_reg = 0;
      4'b0001: out_reg = 1;
      4'b0010: out_reg = 0;
      4'b0011: out_reg = 1;
      4'b0100: out_reg = 1;
      4'b0101: out_reg = 0;
      4'b0110: out_reg = 1;
      4'b0111: out_reg = 0;
      4'b1000: out_reg = 0;
      4'b1001: out_reg = 1;
      4'b1010: out_reg = 1;
      4'b1011: out_reg = 0;
      4'b1100: out_reg = 1;
      4'b1101: out_reg = 0;
      4'b1110: out_reg = 0;
      4'b1111: out_reg = 1;
      default: out_reg = 0;
    endcase
  end

  assign out = out_reg;

endmodule