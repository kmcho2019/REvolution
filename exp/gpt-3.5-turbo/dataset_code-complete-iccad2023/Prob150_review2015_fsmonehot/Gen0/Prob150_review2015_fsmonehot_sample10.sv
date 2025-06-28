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
  assign B3_next = (state == 10'b0000000111); // Next state B3
  assign S_next = (state == 10'b0000000001);  // Next state S
  assign S1_next = (state == 10'b0000000010); // Next state S1
  assign Count_next = (state == 10'b0100000000); // Next state Count
  assign Wait_next = (state == 10'b1000000000); // Next state Wait

  // Output logic
  assign done = (state == 10'b1000000000); // Output done logic
  assign counting = (state == 10'b0100000000); // Output counting logic
  assign shift_ena = (state == 10'b0000001000); // Output shift_ena logic

endmodule