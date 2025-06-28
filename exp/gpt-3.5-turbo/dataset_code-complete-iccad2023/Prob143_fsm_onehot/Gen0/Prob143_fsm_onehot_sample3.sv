module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

  always @* begin
    case(state)
      10'b0000000001: begin // S0
        if(in)
          begin
            next_state = 10'b0000000010; // S1
            out1 = 0;
            out2 = 0;
          end
        else
          begin
            next_state = 10'b0000000001; // S0
            out1 = 0;
            out2 = 0;
          end
      end
      
      10'b0000000010: begin // S1
        if(in)
          begin
            next_state = 10'b0000000100; // S2
            out1 = 0;
            out2 = 0;
          end
        else
          begin
            next_state = 10'b0000000001; // S0
            out1 = 0;
            out2 = 0;
          end
      end
      
      // Add cases for S2, S3, S4, S5, S6, S7, S8, S9 using similar pattern
      
      default: begin
        next_state = 10'b0000000001; // default to S0
        out1 = 0;
        out2 = 0;
      end
    endcase
  end

endmodule