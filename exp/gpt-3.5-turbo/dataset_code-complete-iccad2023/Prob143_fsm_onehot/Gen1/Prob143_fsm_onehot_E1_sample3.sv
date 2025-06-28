module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

always @(*) begin
  case(state)
    10'b0000000001: begin // S0
      out1 = 1'b0;
      out2 = 1'b0;
      next_state = in ? 10'b0000000010 : 10'b0000000001;
    end
    10'b0000000010: begin // S1
      out1 = 1'b0;
      out2 = 1'b0;
      next_state = in ? 10'b0000000100 : 10'b0000000001;
    end
    10'b0000000100: begin // S2
      out1 = 1'b0;
      out2 = 1'b0;
      next_state = in ? 10'b0000001000 : 10'b0000000001;
    end
    10'b0000001000: begin // S3
      out1 = 1'b0;
      out2 = 1'b0;
      next_state = in ? 10'b0000010000 : 10'b0000000001;
    end
    10'b0000010000: begin // S4
      out1 = 1'b0;
      out2 = 1'b0;
      next_state = in ? 10'b0000100000 : 10'b0000000001;
    end
    10'b0000100000: begin // S5
      out1 = 1'b0;
      out2 = 1'b0;
      next_state = in ? 10'b0010000000 : 10'b0000000001;
    end
    10'b0001000000: begin // S6
      out1 = 1'b0;
      out2 = 1'b0;
      next_state = in ? 10'b0100000000 : 10'b0000000001;
    end
    10'b0010000000: begin // S7
      out1 = 1'b0;
      out2 = 1'b1;
      next_state = in ? 10'b0010000000 : 10'b0010000000;     
    end
    10'b0100000000: begin // S8
      out1 = 1'b1;
      out2 = 1'b0;
      next_state = in ? 10'b0000000010 : 10'b0000000001;
    end
    10'b1000000000: begin // S9
      out1 = 1'b1;
      out2 = 1'b1;
      next_state = in ? 10'b0000000010 : 10'b0000000001;
    end
    default: begin
      out1 = 1'b0;
      out2 = 1'b0;
      next_state = 10'b0000000000;
    end
  endcase
end

endmodule