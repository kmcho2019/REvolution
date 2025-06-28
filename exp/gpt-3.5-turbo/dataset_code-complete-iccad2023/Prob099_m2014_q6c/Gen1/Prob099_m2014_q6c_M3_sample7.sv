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
      Y2 = y[1]; // next state B
      Y4 = y[3]; // next state D
    end
    7'b000010: begin // State B
      Y2 = y[2]; // next state C
      Y4 = y[3]; // next state D
    end
    7'b000100: begin // State C
      Y2 = y[2]; // next state C
      Y4 = y[3]; // next state D
    end
    7'b001000: begin // State D
      Y2 = y[1]; // next state A
      Y4 = y[3]; // next state D
    end
    7'b010000: begin // State E
      Y2 = y[1]; // next state A
      Y4 = y[2]; // next state E
    end
    7'b100000: begin // State F
      Y2 = y[1]; // next state A
      Y4 = y[2]; // next state C
    end
    default: begin
      Y2 = 0;
      Y4 = 0;
    end
  endcase
end

endmodule