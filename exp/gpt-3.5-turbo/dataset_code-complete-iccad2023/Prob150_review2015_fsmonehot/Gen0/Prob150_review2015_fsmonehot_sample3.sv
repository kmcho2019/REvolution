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

  // Define state encoding
  parameter S = 10'b0000000001;
  parameter S1 = 10'b0000000010;
  parameter S11 = 10'b0000000100;
  parameter S110 = 10'b0000001000;
  parameter B0 = 10'b0000010000;
  parameter B1 = 10'b0000100000;
  parameter B2 = 10'b0001000000;
  parameter B3 = 10'b0010000000;
  parameter Count = 10'b0100000000;
  parameter Wait = 10'b1000000000;

  // State transition logic
  assign B3_next = (state == B2);
  assign S_next = (state == Wait);
  assign S1_next = (state == S11);
  assign Count_next = (state == Count);
  assign Wait_next = (state == Wait);

  // Output logic equations
  assign done = (state == Wait) ? 1'b1 : 1'b0;
  assign counting = (state == Count) ? 1'b1 : 1'b0;
  assign shift_ena = (state == B0 || state == B1 || state == B2 || state == B3) ? 1'b1 : 1'b0;

endmodule