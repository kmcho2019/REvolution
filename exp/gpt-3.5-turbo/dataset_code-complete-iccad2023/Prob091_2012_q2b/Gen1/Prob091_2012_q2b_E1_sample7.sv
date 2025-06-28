module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  always @(*) begin
    case(y)
      6'b000001: Y1 = w ? 1'b0 : 1'b0; // State A (0)
      6'b000010: Y1 = w ? 1'b0 : 1'b0; // State B (0)
      6'b000100: Y1 = w ? 1'b0 : 1'b1; // State C (0)
      6'b001000: Y1 = w ? 1'b0 : 1'b0; // State D (0)
      6'b010000: Y1 = w ? 1'b1 : 1'b1; // State E (1)
      6'b100000: Y1 = w ? 1'b1 : 1'b1; // State F (1)
      default: Y1 = 1'b0;
    endcase
  end

  always @(*) begin
    case(y)
      6'b000001: Y3 = w ? 1'b0 : 1'b0; // State A (0)
      6'b000010: Y3 = w ? 1'b0 : 1'b0; // State B (0)
      6'b000100: Y3 = w ? 1'b0 : 1'b1; // State C (0)
      6'b001000: Y3 = w ? 1'b0 : 1'b0; // State D (0)
      6'b010000: Y3 = w ? 1'b0 : 1'b0; // State E (1)
      6'b100000: Y3 = w ? 1'b0 : 1'b1; // State F (1)
      default: Y3 = 1'b0;
    endcase
  end

endmodule