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
always @* begin
  B3_next = (state == 10'b0000001000);
  S_next = (state == 10'b0000000001);
  S1_next = (state == 10'b0000000010);
  Count_next = (state == 10'b1000000000);
  Wait_next = (state == 10'b0100000000);
end

// Output logic equations based on the given Moore state machine
assign done = (state == 10'b0100000000) | (state == 10'b1000000000);
assign counting = (state == 10'b1000000000) | (state == 10'b0100000000);
assign shift_ena = (state == 10'b0000001000);

endmodule