module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);

  always @(*) begin
    case (y)
      3'b001: Y2 = 1'b1;                 // B: Y2=1 regardless of w
      3'b010: Y2 = w;                    // C: Y2=1 if w=1
      3'b101: Y2 = ~w;                   // F: Y2=1 if w=0
      default: Y2 = 1'b0;                // others Y2=0
    endcase
  end

endmodule