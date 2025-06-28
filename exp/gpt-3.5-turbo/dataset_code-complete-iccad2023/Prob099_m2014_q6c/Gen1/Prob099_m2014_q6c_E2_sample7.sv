module TopModule (
  input [6:1] y,
  input w,
  output reg Y2,
  output reg Y4
);

  always @* begin
    case(y)
      7'b000001: begin
        Y2 = ~w;
        Y4 = w;
      end
      7'b000010: begin
        Y2 = w;
        Y4 = ~w;
      end
      7'b000100: begin
        Y2 = w;
        Y4 = ~w;
      end
      7'b001000: begin
        Y2 = ~w;
        Y4 = w;
      end
      7'b010000: begin
        Y2 = w;
        Y4 = ~w;
      end
      7'b100000: begin
        Y2 = w;
        Y4 = ~w;
      end
      default: begin
        Y2 = 0;
        Y4 = 0;
      end
    endcase
  end

endmodule