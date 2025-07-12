module TopModule(y, w, Y1, Y2, Y3, Y4);
  input [5:0] y;
  input w;
  output Y1;
  output Y2;
  output Y3;
  output Y4;

  reg [5:0] next_state;

  always @(y, w) begin
    case (1'b1)
      y[0]: next_state = w? 6'b000001 : 6'b000010; // State A transitions
      y[1]: next_state = w? 6'b001000 : 6'b000100; // State B transitions
      y[2]: next_state = w? 6'b001000 : 6'b010000; // State C transitions
      y[3]: next_state = w? 6'b000001 : 6'b100000; // State D transitions
      y[4]: next_state = w? 6'b001000 : 6'b010000; // State E transitions
      y[5]: next_state = w? 6'b001000 : 6'b000100; // State F transitions
    endcase
  end

  assign Y1 = next_state[0];
  assign Y2 = next_state[1];
  assign Y3 = next_state[2];
  assign Y4 = next_state[3];

endmodule