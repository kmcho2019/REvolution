module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);

always @(*) begin
  case (y)
    3'b000: Y2 = 1'b0; // State A
    3'b001: Y2 = 1'b1; // State B -> next state will be C or D (both have y[2]=1)
    3'b010: Y2 = 1'b1; // State C -> next state will be E or D (both have y[2]=1)
    3'b011: Y2 = ~w;   // State D -> next state F (y[2]=1) if w=0, else A (y[2]=0)
    3'b100: Y2 = 1'b1; // State E -> next state stays E or goes D (both have y[2]=1)
    3'b101: Y2 = 1'b1; // State F -> next state C or D (both have y[2]=1)
    default: Y2 = 1'b0;
  endcase
end

endmodule