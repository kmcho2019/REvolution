module TopModule(x3, x2, x1, f);
  input x3, x2, x1;
  output f;
  reg f;

  always @(x3, x2, x1)
    begin
      case ({x3, x2, x1})
        3'b000: f = 1'b0;
        3'b001: f = 1'b0;
        3'b010: f = 1'b1;
        3'b011: f = 1'b1;
        3'b100: f = 1'b0;
        3'b101: f = 1'b1;
        3'b110: f = 1'b0;
        3'b111: f = 1'b1;
      endcase
    end
endmodule