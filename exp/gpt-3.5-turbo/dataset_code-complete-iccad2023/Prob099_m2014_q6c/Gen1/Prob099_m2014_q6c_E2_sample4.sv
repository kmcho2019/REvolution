module TopModule (
  input [6:1] y,
  input w,
  output reg Y2,
  output reg Y4
);

  always @* begin
    case(y)
      7'b000001: begin // State A
        Y2 = y[4]; // Next-state for y[2]
        Y4 = y[4]; // Next-state for y[4]
      end
      7'b000010: begin // State B
        Y2 = y[1]; // Next-state for y[2]
        Y4 = y[2]; // Next-state for y[4]
      end
      7'b000100: begin // State C
        Y2 = y[2]; // Next-state for y[2]
        Y4 = y[2]; // Next-state for y[4]
      end
      7'b001000: begin // State D
        Y2 = y[2]; // Next-state for y[2]
        Y4 = y[1]; // Next-state for y[4]
      end
      7'b010000: begin // State E
        Y2 = y[1]; // Next-state for y[2]
        Y4 = y[1]; // Next-state for y[4]
      end
      7'b100000: begin // State F
        Y2 = y[1]; // Next-state for y[2]
        Y4 = y[2]; // Next-state for y[4]
      end
    endcase
  end

endmodule