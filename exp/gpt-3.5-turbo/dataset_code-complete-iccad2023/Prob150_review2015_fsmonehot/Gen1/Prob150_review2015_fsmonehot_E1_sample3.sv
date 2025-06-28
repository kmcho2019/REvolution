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
  assign B3_next = (state == 10'b0001000000);
  assign S_next = (state == 10'b1000000001);
  assign S1_next = (state == 10'b0000000001) ? d : ((state == 10'b0000000010) ? d : (state == 10'b0000000011));
  assign Count_next = (state == 10'b0100000000) & ~done_counting;
  assign Wait_next = (state == 10'b1000000000) & ack;

  // Output logic
  assign done = (state == 10'b1000000000);
  assign counting = (state == 10'b0100000000);
  assign shift_ena = (state == 10'b0000010000);

endmodule