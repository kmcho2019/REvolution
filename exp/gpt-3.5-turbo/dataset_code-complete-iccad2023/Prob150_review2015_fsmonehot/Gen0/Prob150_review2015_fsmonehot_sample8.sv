module TopModule (
  input d,
  input done_counting,
  input ack,
  input [9:0] state,
  output B3_next,
  output S_next,
  output S1_next,
  output Count_next,
  output Wait_next,
  output done,
  output counting,
  output shift_ena
);

  assign B3_next = (state == 10'b0000001000);
  assign S_next = (state == 10'b0000000001);
  assign S1_next = (state == 10'b0000000010);
  assign Count_next = (state == 10'b1000000000);
  assign Wait_next = (state == 10'b0000000010);

  assign done = (state == 10'b1000000000) ? 1 : 0;
  assign counting = ((state == 10'b1000000000) && (done_counting == 0)) ? 1 : 0;
  assign shift_ena = (state == 10'b0000000111) ? 1 : 0;

endmodule