module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

  // Define the states using parameters
  parameter S0 = 10'b0000000001;
  parameter S1 = 10'b0000000010;
  parameter S2 = 10'b0000000100;
  parameter S3 = 10'b0000001000;
  parameter S4 = 10'b0000010000;
  parameter S5 = 10'b0000100000;
  parameter S6 = 10'b0001000000;
  parameter S7 = 10'b0010000000;
  parameter S8 = 10'b0100000000;
  parameter S9 = 10'b1000000000;

  // State transition and output logic
  always @* begin
    case(state)
      S0: begin
        out1 = 1'b0;
        out2 = 1'b0;
        next_state = (in == 1'b1) ? S1 : S0;
      end
      S1: begin
        out1 = 1'b0;
        out2 = 1'b0;
        next_state = (in == 1'b1) ? S2 : S0;
      end
      S2: begin
        out1 = 1'b0;
        out2 = 1'b0;
        next_state = (in == 1'b1) ? S3 : S0;
      end
      S3: begin
        out1 = 1'b0;
        out2 = 1'b0;
        next_state = (in == 1'b1) ? S4 : S0;
      end
      S4: begin
        out1 = 1'b0;
        out2 = 1'b0;
        next_state = (in == 1'b1) ? S5 : S0;
      end
      S5: begin
        out1 = (in == 1'b1);
        out2 = 1'b0;
        next_state = (in == 1'b1) ? S6 : S8;
      end
      S6: begin
        out1 = 1'b0;
        out2 = 1'b0;
        next_state = (in == 1'b1) ? S7 : S9;
      end
      S7: begin
        out1 = 1'b1;
        out2 = (in == 1'b1);
        next_state = (in == 1'b1) ? S7 : S0;
      end
      S8: begin
        out1 = 1'b0;
        out2 = 1'b0;
        next_state = (in == 1'b1) ? S1 : S0;
      end
      S9: begin
        out1 = (in == 1'b1);
        out2 = (in == 1'b1);
        next_state = (in == 1'b1) ? S1 : S0;
      end
    endcase
  end

endmodule