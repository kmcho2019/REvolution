module TopModule (
  input [6:1] y,
  input w,
  output reg Y2,
  output reg Y4
);

always @*
begin
  case(y)
    7'b000001: begin // State A
      Y2 = 0;
      Y4 = 0;
    end
    7'b000010: begin // State B
      Y2 = 0;
      Y4 = 1;
    end
    7'b000100: begin // State C
      Y2 = 0;
      Y4 = 1;
    end
    7'b001000: begin // State D
      Y2 = 0;
      Y4 = 1;
    end
    7'b010000: begin // State E
      Y2 = 1;
      Y4 = 1;
    end
    7'b100000: begin // State F
      Y2 = 1;
      Y4 = 0;
    end
    default: begin
      Y2 = 0;
      Y4 = 0;
    end
  endcase
end

endmodule