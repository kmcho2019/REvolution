module StateTransition (
  input x,
  input [2:0] y,
  output reg [2:0] Y
);
  
always @(*) begin
  case ({y, x})
    3'b0000: Y = 3'b001;
    3'b0001: Y = 3'b000;
    3'b0010: Y = 3'b001;
    3'b0011: Y = 3'b010;
    3'b0100: Y = 3'b001;
    default: Y = 3'b000; // default to state 000
  endcase
end

endmodule

module OutputLogic (
  input [2:0] Y,
  output reg Y0,
  output reg z
);

always @(*) begin
  case (Y)
    3'b011: begin
              Y0 = 0;
              z = 1;
           end
    3'b100: begin
              Y0 = 1;
              z = 1;
           end
    default: begin
               Y0 = 0;
               z = 0;
             end
  endcase
end

endmodule

module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

reg [2:0] Y;

StateTransition st (
  .x(x),
  .y(y),
  .Y(Y)
);

OutputLogic ol (
  .Y(Y),
  .Y0(Y0),
  .z(z)
);

endmodule