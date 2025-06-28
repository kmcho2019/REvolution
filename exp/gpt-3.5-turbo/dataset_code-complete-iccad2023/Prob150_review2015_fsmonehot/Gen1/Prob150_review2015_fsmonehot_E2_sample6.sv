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

  // Output Logic
  assign done = (state == 10'b1000000000) ? 1'b1 : 1'b0; // done only in Wait state
  assign counting = (state == 10'b1000000000) ? 1'b1 : 1'b0; // counting only in Count state
  assign shift_ena = (state >= 10'b0110000000) ? 1'b1 : 1'b0; // shift_ena in B0 state onwards

  // State Transition Logic
  assign B3_next = (state == 10'b0000000010) ? 1'b1 : 1'b0; // Next state is B3 from B2
  assign S_next = (state == 10'b1000000000 || state == 10'b0000000001) ? 1'b1 : 1'b0; // Next state is S from B3 or Wait
  assign S1_next = (state == 10'b0000000001) ? 1'b1 : 1'b0; // Next state is S1 from S
  assign Count_next = (state == 10'b1000000000) ? 1'b1 : 1'b0; // Next state is Count from Wait
  assign Wait_next = (state == 10'b1000000000) ? 1'b1 : 1'b0; // Next state is Wait from Count

endmodule