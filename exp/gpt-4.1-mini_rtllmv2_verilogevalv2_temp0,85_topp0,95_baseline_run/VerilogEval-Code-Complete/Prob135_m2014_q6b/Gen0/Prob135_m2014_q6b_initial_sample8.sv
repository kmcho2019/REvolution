module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);
  always @(*) begin
    // Decode states
    wire B = (y == 3'b001);
    wire C = (y == 3'b010);
    wire D = (y == 3'b011);
    wire E = (y == 3'b100);
    wire F = (y == 3'b101);

    if (B)
      Y2 = 1'b1;
    else if (C)
      Y2 = 1'b1;
    else if (E)
      Y2 = 1'b1;
    else if (F)
      Y2 = 1'b1;
    else if (D && (w == 1'b0))
      Y2 = 1'b1;
    else
      Y2 = 1'b0;
  end
endmodule