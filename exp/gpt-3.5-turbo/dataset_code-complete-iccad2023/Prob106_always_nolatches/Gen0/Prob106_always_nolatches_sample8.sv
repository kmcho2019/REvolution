module TopModule (
  input [15:0] scancode,
  output reg left,
  output reg down,
  output reg right,
  output reg up
);

always @(*)
begin
  case(scancode[15:8])
    8'hE0:
      case(scancode[7:0])
        8'h6B: left = 1;
        8'h72: down = 1;
        8'h74: right = 1;
        8'h75: up = 1;
        default: begin
                   left = 0;
                   down = 0;
                   right = 0;
                   up = 0;
                 end
      endcase
    default: begin
               left = 0;
               down = 0;
               right = 0;
               up = 0;
             end
  endcase
end

endmodule