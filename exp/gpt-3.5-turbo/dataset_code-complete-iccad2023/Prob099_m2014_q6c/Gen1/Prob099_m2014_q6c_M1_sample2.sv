module TopModule (
  input [6:1] y,
  input w,
  output reg Y2,
  output reg Y4
);

always @*
begin
  // Default state assignments
  Y2 = 0;
  Y4 = 0;

  // Update values based on current state
  case(y)
    7'b000001: Y4 = 0; // State A
    7'b000010: Y4 = 1; // State B
    7'b000100: Y4 = 1; // State C
    7'b001000: Y4 = 1; // State D
    7'b010000: Y2 = 1; Y4 = 1; // State E
    7'b100000: Y2 = 1; // State F
  endcase
end

endmodule