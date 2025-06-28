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

  // State transition encoding
  localparam S = 10'b0000000001;
  localparam S1 = 10'b0000000010;
  localparam S11 = 10'b0000000100;
  localparam S110 = 10'b0000001000;
  localparam B0 = 10'b0000010000;
  localparam B1 = 10'b0000100000;
  localparam B2 = 10'b0001000000;
  localparam B3 = 10'b0010000000;
  localparam Count = 10'b0100000000;
  localparam Wait = 10'b1000000000;

  // Next-state logic equations
  always @* begin
    case (state)
      S: state = (d) ? S1 : S;
      S1: state = (d) ? S11 : S;
      S11: state = (d) ? S11 : S110;
      S110: state = (d) ? B0 : S;
      B0: state = B1;
      B1: state = B2;
      B2: state = B3;
      B3: state = Count;
      Count: state = (done_counting) ? Wait : Count;
      Wait: state = (ack) ? S : Wait;
    endcase
  end

  // Output logic equations
  assign B3_next = (state == B3) ? 1 : 0;
  assign S_next = (state == S) ? 1 : 0;
  assign S1_next = (state == S1) ? 1 : 0;
  assign Count_next = (state == Count) ? 1 : 0;
  assign Wait_next = (state == Wait) ? 1 : 0;
  assign done = (state == Wait && ack) ? 1 : 0;
  assign counting = (state == Count && !done_counting) ? 1 : 0;
  assign shift_ena = (state == B0) ? 1 : 0;

endmodule