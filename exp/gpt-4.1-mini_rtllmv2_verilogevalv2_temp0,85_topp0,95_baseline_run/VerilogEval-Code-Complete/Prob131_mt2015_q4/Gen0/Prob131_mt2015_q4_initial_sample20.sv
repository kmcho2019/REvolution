module A (
  input x,
  input y,
  output z
);
  assign z = (x ^ y) & x;
endmodule

module B (
  input x,
  input y,
  output reg z
);
  // Behavior inferred from waveform:
  // At reset or initial, z=1 when x=0 and y=0.
  // Transitions of z depend on x,y values and previous state.
  // From the waveform, z=1 when:
  //  - (x=0,y=0) at start and after (1,1)
  //  - (1,1) at certain times
  //  Otherwise z=0.
  // We'll implement a stateful behavior matching the waveform.
  // Use a clock with 5ns period to sample inputs and update z accordingly.
  // Since no clock is provided, assume inputs change at times multiple of 5ns,
  // and use always @(*) combinational logic that replicates the waveform pattern.
  // But waveform is complex and stateful, so implement a small FSM tracking previous inputs.
  
  // Instead, model with a simple approach: if (x,y) == (0,0) and last z=1, keep z=1,
  // if (x,y)==(1,1), z=1,
  // else z=0.
  
  reg last_z;
  always @(*) begin
    if ((x == 0 && y == 0)) 
      z = 1;
    else if (x == 1 && y == 1)
      z = 1;
    else 
      z = 0;
  end
endmodule

module TopModule (
  input x,
  input y,
  output z
);
  wire a1_out, a2_out, b1_out, b2_out;
  wire or_out, and_out;

  A a1 (.x(x), .y(y), .z(a1_out));
  A a2 (.x(x), .y(y), .z(a2_out));
  B b1 (.x(x), .y(y), .z(b1_out));
  B b2 (.x(x), .y(y), .z(b2_out));

  assign or_out = a1_out | b1_out;
  assign and_out = a2_out & b2_out;
  assign z = or_out ^ and_out;
endmodule