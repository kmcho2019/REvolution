module TopModule (
  input [6:1] y,
  input w,
  output reg Y2,
  output reg Y4
);

always @*
begin
  case(y)
    7'b000001, 7'b000010, 7'b100000: begin // States A, B, F
      Y2 = 0;
      Y4 = 0;
    end
    7'b000100, 7'b001000: begin // States C, D
      Y2 = 0;
      Y4 = 1;
    end
    7'b010000: begin // State E
      Y2 = 1;
      Y4 = 1;
    end
    default: begin
      Y2 = 0;
      Y4 = 0;
    end
  endcase
end

endmodule