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

  // State Transition Logic
  assign B3_next = (state == 10'b0110000000); // State transition to B3 from B2
  assign S_next = (state == 10'b1110000000) ? 1'b1 : 1'b0; // State transition to S from Wait condition
  assign S1_next = (state == 10'b0100000000); // State transition to S1 from S
  assign Count_next = (state == 10'b0100000000) ? 1'b1 : 1'b0; // State transition to Count from Wait condition
  assign Wait_next = (state == 10'b1000000000); // State transition to Wait from Count
  
  // Output Logic
  assign done = (state == 10'b1000000000) ? 1'b1 : 1'b0; // done is high only in Wait state
  assign counting = (state == 10'b0100000000) ? 1'b1 : 1'b0; // counting is high only in Count state
  assign shift_ena = (state >= 10'b0110000000) ? 1'b1 : 1'b0; // shift_ena is high from B0 state onwards

endmodule