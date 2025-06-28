module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

  // State transition and output logic based on the provided state machine diagram

  always @* begin
    case(state)
      10'b0000000001: begin  // S0
        next_state = 10'b0000000010;
        out1 = 1'b0;
        out2 = 1'b0;
      end
      10'b0000000010: begin  // S1
        if(in == 1'b0)
          next_state = 10'b0000000001;
        else
          next_state = 10'b0000000100;
        out1 = 1'b0;
        out2 = 1'b0;
      end
      10'b0000000100: begin  // S2
        if(in == 1'b0)
          next_state = 10'b0000000001;
        else
          next_state = 10'b0000001000;
        out1 = 1'b0;
        out2 = 1'b0;
      end
      10'b0000001000: begin  // S3
        if(in == 1'b0)
          next_state = 10'b0000000001;
        else
          next_state = 10'b0000010000;
        out1 = 1'b0;
        out2 = 1'b0;
      end
      10'b0000010000: begin  // S4
        if(in == 1'b0)
          next_state = 10'b0000000001;
        else
          next_state = 10'b0000100000;
        out1 = 1'b0;
        out2 = 1'b0;
      end
      10'b0000100000: begin  // S5
        if(in == 1'b0)
          next_state = 10'b0100000000;
        else
          next_state = 10'b0001000000;
        out1 = 1'b0;
        out2 = 1'b0;
      end
      10'b0001000000: begin  // S6
        if(in == 1'b0)
          next_state = 10'b0010000000;
        else
          next_state = 10'b0010000000;
        out1 = 1'b0;
        out2 = 1'b0;
      end
      10'b0010000000: begin  // S7
        if(in == 1'b0)
          next_state = 10'b0000000001;
        else
          next_state = 10'b0010000000;
        out1 = 1'b0;
        out2 = 1'b1;
      end
      10'b0100000000: begin  // S8
        if(in == 1'b0)
          next_state = 10'b0000000001;
        else
          next_state = 10'b0000000010;
        out1 = 1'b1;
        out2 = 1'b0;
      end
      10'b1000000000: begin  // S9
        if(in == 1'b0)
          next_state = 10'b0000000001;
        else
          next_state = 10'b0000000010;
        out1 = 1'b1;
        out2 = 1'b1;
      end
      default: begin
        next_state = 10'b0;
        out1 = 1'b0;
        out2 = 1'b0;
      end
    endcase
  end

endmodule