module TopModule (
  input d,
  input done_counting,
  input ack,
  input [9:0] state, // 10-bit one-hot current state
  output B3_next,
  output S_next,
  output S1_next,
  output Count_next,
  output Wait_next,
  output done,
  output counting,
  output shift_ena
);

  // State transition logic
  assign S_next = (state == 10'b0000000001) ? (d == 1'b0) : 1'b0;
  assign S1_next = (state == 10'b0000000010) ? (d == 1'b1) : 1'b0;
  assign Count_next = (state == 10'b0100000000) ? ~done_counting : ((state == 10'b1000000000) & ack);
  assign Wait_next = (state == 10'b1000000000) ? ack : ((state == 10'b0000000010) | (state == 10'b1000000000));

  // Special cases for B3 and B0 transitions
  assign B3_next = (state == 10'b0010000000);
  assign S1_next = (state == 10'b0000000010);

  // Output logic
  assign done = (state == 10'b1000000000);
  assign counting = (state == 10'b0100000000);
  assign shift_ena = (state == 10'b0000010000);

endmodule