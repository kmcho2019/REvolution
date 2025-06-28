module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  always @*
  begin
    case({y, w})
      7'b0000010: begin // State A, w=0
        Y2 = 0;
        Y4 = 0;
      end
      7'b0000011: begin // State A, w=1
        Y2 = 0;
        Y4 = 1;
      end
      7'b0000100: begin // State B, w=0
        Y2 = 0;
        Y4 = 0;
      end
      7'b0000101: begin // State B, w=1
        Y2 = 0;
        Y4 = 1;
      end
      7'b0001000: begin // State C, w=0
        Y2 = 0;
        Y4 = 1;
      end
      7'b0001001: begin // State C, w=1
        Y2 = 0;
        Y4 = 1;
      end
      7'b0010000: begin // State D, w=0
        Y2 = 0;
        Y4 = 1;
      end
      7'b0010001: begin // State D, w=1
        Y2 = 0;
        Y4 = 1;
      end
      7'b0100000: begin // State E, w=0
        Y2 = 1;
        Y4 = 0;
      end
      7'b0100001: begin // State E, w=1
        Y2 = 0;
        Y4 = 1;
      end
      7'b1000000: begin // State F, w=0
        Y2 = 1;
        Y4 = 0;
      end
      7'b1000001: begin // State F, w=1
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