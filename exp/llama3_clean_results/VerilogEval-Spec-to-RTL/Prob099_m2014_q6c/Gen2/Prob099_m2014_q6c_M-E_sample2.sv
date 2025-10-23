module TopModule(y, w, Y1, Y3);
  input [5:0] y;
  input w;
  output Y1;
  output Y3;

  reg Y1_reg;
  reg Y3_reg;

  always @(*) begin
    case (1'b1)
      y[0]: begin
        if (~w) Y1_reg = 0; else Y1_reg = 1;
        if (~w) Y3_reg = 0; else Y3_reg = 0;
      end
      y[1]: begin
        if (~w) Y1_reg = 0; else Y1_reg = 0;
        if (~w) Y3_reg = 0; else Y3_reg = 1;
      end
      y[2]: begin
        if (~w) Y1_reg = 0; else Y1_reg = 0;
        if (~w) Y3_reg = 0; else Y3_reg = 1;
      end
      y[3]: begin
        if (~w) Y1_reg = 1; else Y1_reg = 0;
        if (~w) Y3_reg = 0; else Y3_reg = 0;
      end
      y[4]: begin
        if (~w) Y1_reg = 0; else Y1_reg = 1;
        if (~w) Y3_reg = 0; else Y3_reg = 1;
      end
      y[5]: begin
        if (~w) Y1_reg = 1; else Y1_reg = 0;
        if (~w) Y3_reg = 0; else Y3_reg = 0;
      end
      default: begin
        Y1_reg = 0;
        Y3_reg = 0;
      end
    endcase
  end

  assign Y1 = Y1_reg;
  assign Y3 = Y3_reg;

endmodule