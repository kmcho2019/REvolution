module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);
  
  always @* begin
    case(y[2:1])
      2'b00: if (w) Y2 = 1; else Y2 = 0;
      2'b01: if (w) Y2 = 0; else Y2 = 1;
      2'b10: if (w) Y2 = 1; else Y2 = 0;
      2'b11: if (w) Y2 = 0; else Y2 = 1;
    endcase
  end
  
endmodule