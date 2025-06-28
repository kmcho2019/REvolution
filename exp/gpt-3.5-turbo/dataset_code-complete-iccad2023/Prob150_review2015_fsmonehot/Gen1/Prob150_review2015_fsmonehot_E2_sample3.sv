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
  assign counting = (state == 10'b0100000000) ? 1'b1 : 1'b0; // counting only in Count state
  assign shift_ena = (state >= 10'b0000010000) ? 1'b1 : 1'b0; // shift_ena in B0 state onwards

  // State Transition Logic
  assign B3_next = (state == 10'b0001000000) ? 1'b1 : 1'b0; // Next state is B3 from B2
  assign S_next = (state == 10'b1000000000) ? 1'b1 : 1'b0; // Next state is S from Wait
  assign S1_next = (state == 10'b0000000001) ? d : (state == 10'b0000000010); // Next states S1 from S with d=1, S1 from S1 with d=0 
  assign Count_next = (state == 10'b1000000000) ? ~done_counting : (state == 10'b0100000000 & done_counting); // Next state is Count from Wait and done_counting=0 or Count to Wait when done_counting=1
  assign Wait_next = (state == 10'b0100000000) ? 1'b1 : 1'b0; // Next state is Wait from Count

endmodule