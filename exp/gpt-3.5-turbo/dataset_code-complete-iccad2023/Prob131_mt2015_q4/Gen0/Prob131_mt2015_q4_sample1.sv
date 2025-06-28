module TopModule (
  input x,
  input y,
  output z
);

  // Instantiate two instances of module A
  A a1(
    .x(x),
    .y(y),
    .z(out_a1)
  );
  
  A a2(
    .x(x),
    .y(y),
    .z(out_a2)
  );

  // Instantiate two instances of module B
  B b1(
    .x(x),
    .y(y),
    .z(out_b1)
  );
  
  B b2(
    .x(x),
    .y(y),
    .z(out_b2)
  );

  // OR gate
  assign or_result = out_a1 | out_b1;
  
  // AND gate
  assign and_result = out_a2 & out_b2;

  // XOR gate
  assign z = or_result ^ and_result;
  
endmodule