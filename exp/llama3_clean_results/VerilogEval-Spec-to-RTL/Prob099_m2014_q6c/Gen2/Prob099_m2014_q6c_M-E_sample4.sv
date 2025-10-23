module TopModule(y, w, Y1, Y3);
  input [5:0] y;
  input w;
  output Y1;
  output Y3;

  always @(y, w) begin
    case ({y, w})
      6'b000001_0: Y1 = 1'b1; // From A with w=0
      6'b001000_1: Y1 = 1'b1; // From D with w=1
      6'b100000_0: Y1 = 1'b1; // From F with w=0
      default: Y1 = 1'b0;
    endcase

    case ({y, w})
      6'b000010_0: Y3 = 1'b1; // From B with w=0
      6'b000100_0: Y3 = 1'b1; // From C with w=0
      6'b010000_1: Y3 = 1'b1; // From E with w=1
      default: Y3 = 1'b0;
    endcase
  end
endmodule