module TopModule(y, w, Y1);
  input [2:0] y;
  input w;
  output Y1;

  assign Y1 = y[1];

  reg [1:0] next_y1;
  always @(y or w) begin
    case (y)
      3'b000: // State A
        if (~w) next_y1 = 2'b01; // Transition to B
        else next_y1 = 2'b00; // Stay in A
      3'b001: // State B
        if (~w) next_y1 = 2'b10; // Transition to C
        else next_y1 = 2'b11; // Transition to D
      3'b010: // State C
        if (~w) next_y1 = 2'b11; // Transition to E
        else next_y1 = 2'b11; // Transition to D
      3'b011: // State D
        if (~w) next_y1 = 2'b00; // Transition to F (y[1] becomes 0 in F)
        else next_y1 = 2'b00; // Transition to A
      3'b100: // State E
        if (~w) next_y1 = 2'b11; // Stay in E
        else next_y1 = 2'b11; // Transition to D
      3'b101: // State F
        if (~w) next_y1 = 2'b10; // Transition to C
        else next_y1 = 2'b11; // Transition to D
      default:
        next_y1 = 2'bx;
    endcase
  end

  assign Y1 = next_y1[1];
endmodule