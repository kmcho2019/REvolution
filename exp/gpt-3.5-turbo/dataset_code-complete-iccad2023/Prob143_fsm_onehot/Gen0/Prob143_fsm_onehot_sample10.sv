module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

  // State transition logic
  always @(*)
    case (state)
      10'b0000000001: next_state = 10'b0000000010;
      10'b0000000010: next_state = (in) ? 10'b0000001000 : 10'b000000001;
      10'b0000000100: next_state = (in) ? 10'b0000001000 : 10'b0000000101;
      10'b0000001010: next_state = (in) ? 10'b000000001 : 10'b0000001010;
      10'b0000001100: next_state = (in) ? 10'b0000000011 : 10'b0000001100;
      10'b0000010000: next_state = 10'b000000001;
      10'b0000010010: next_state = 10'b0000000100;
      10'b0000010100: next_state = 10'b0000001000;
      10'b0000010110: next_state = 10'b0000001001;
      10'b0000100000: next_state = 10'b000000001;
      10'b0000100010: next_state = (in) ? 10'b0000000100 : 10'b0000001000;
      10'b0000100100: next_state = (in) ? 10'b0000000101 : 10'b0000001010;
      10'b0000100110: next_state = (in) ? 10'b0000000111 : 10'b0000000110;
      10'b0001000000: next_state = 10'b000000001;
      10'b0000110000: next_state = 10'b0000001000;
      10'b0001000000: next_state = (in) ? 10'b000000001 : 10'b0000010010;
      10'b0001001000: next_state = (in) ? 10'b000000001 : 10'b0000010010;

      default: next_state = 0; // Default case, no state transition

    endcase

  // Output logic
  assign out1 = (state == 10'b0000100100) ? 1 : 0;
  assign out2 = (state == 10'b0000010110 || state == 10'b0000100110 || state == 10'b0001001000) ? 1 : 0;

endmodule