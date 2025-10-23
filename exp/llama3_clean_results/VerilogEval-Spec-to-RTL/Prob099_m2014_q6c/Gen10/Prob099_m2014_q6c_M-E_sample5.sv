module TopModule(y, w, Y1, Y3, Y2, Y4);
  input [5:0] y;
  input w;
  output Y1;
  output Y3;
  output Y2;
  output Y4;

  reg Y1, Y2, Y3, Y4;

  always @(y or w)
  begin
    case (1'b1)
      y[0]: // State A
        begin
          if (~w) Y1 = 1'b1;
          else Y1 = 1'b0;
          Y2 = 1'b0;
          Y3 = 1'b0;
          Y4 = 1'b0;
        end
      y[1]: // State B
        begin
          if (~w) Y2 = 1'b0;
          else Y2 = 1'b0;
          Y1 = 1'b0;
          Y3 = 1'b0;
          Y4 = 1'b0;
        end
      y[2]: // State C
        begin
          if (~w) Y3 = 1'b1;
          else Y3 = 1'b0;
          Y1 = 1'b0;
          Y2 = 1'b0;
          Y4 = 1'b0;
        end
      y[3]: // State D
        begin
          if (~w) Y4 = 1'b1;
          else Y4 = 1'b0;
          Y1 = 1'b0;
          Y2 = 1'b0;
          Y3 = 1'b0;
        end
      y[4]: // State E
        begin
          if (w) Y4 = 1'b0;
          else Y4 = 1'b0;
          Y1 = 1'b0;
          Y2 = 1'b0;
          Y3 = 1'b1;
        end
      y[5]: // State F
        begin
          if (~w) Y3 = 1'b0;
          else Y3 = 1'b0;
          Y1 = 1'b0;
          Y2 = 1'b0;
          Y4 = 1'b1;
        end
    endcase
  end

endmodule