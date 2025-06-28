module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

assign Y2 = y[1]; // Y2 is the next state bit for y[2]

always @(*) begin
  case(y)
    7'b000001: Y4 = 1'b0; // A (0) --1--> A
    7'b000010: Y4 = 1'b0; // B (0) --1--> D
    7'b000100: Y4 = 1'b1; // C (0) --1--> D
    7'b001000: Y4 = 1'b0; // D (0) --1--> A
    7'b010000: Y4 = 1'b1; // E (1) --1--> D
    7'b100000: Y4 = 1'b1; // F (1) --1--> D
    default: Y4 = 1'b0;
  endcase
end

endmodule