module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  reg Y2, Y4;

  always @* begin
    case(y)
      7'b000001: begin // State A
        Y2 = w ? 1 : 0;
        Y4 = 0;
      end
      7'b000010: begin // State B
        Y2 = y[1];
        Y4 = y[2];
      end
      7'b000100: begin // State C
        Y2 = y[2];
        Y4 = y[2];
      end
      7'b001000: begin // State D
        Y2 = y[2];
        Y4 = y[1];
      end
      7'b010000: begin // State E
        Y2 = y[1];
        Y4 = y[1];
      end
      7'b100000: begin // State F
        Y2 = y[1];
        Y4 = y[2];
      end
      default: begin // Reset to State A
        Y2 = 0;
        Y4 = 0;
      end
    endcase
  end

  assign Y2 = Y2;
  assign Y4 = Y4;

endmodule