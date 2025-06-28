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

// State definition
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

// Next-state logic
always @(*) begin
  case(state)
    S: begin
      if (d) state = S1;
      else state = S;
    end
    S1: begin
      if (d) state = S11;
      else state = S;
    end
    S11: begin
      if (d) state = S11;
      else state = S110;
    end
    S110: begin
      if (d) state = B0;
      else state = S;
    end
    B0: state = B1;
    B1: state = B2;
    B2: state = B3;
    B3: state = Count;
    Count: begin
      if (done_counting) state = Wait;
      else state = Count;
    end
    Wait: begin
      if (ack) state = S;
      else state = Wait;
    end
  endcase
end

// Output logic
assign B3_next = (state == B3) ? 1'b1 : 1'b0;
assign S_next = (state == S) ? 1'b1 : 1'b0;
assign S1_next = (state == S1) ? 1'b1 : 1'b0;
assign Count_next = (state == Count) ? 1'b1 : 1'b0;
assign Wait_next = (state == Wait) ? 1'b1 : 1'b0;
assign done = (state == Wait) ? 1'b1 : 1'b0;
assign counting = (state == Count) ? 1'b1 : 1'b0;
assign shift_ena = (state == B0) ? 1'b1 : 1'b0;

endmodule