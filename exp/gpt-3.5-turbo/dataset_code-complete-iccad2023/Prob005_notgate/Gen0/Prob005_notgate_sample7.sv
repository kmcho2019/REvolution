module NotGate (
  input in,
  output out
);
  assign out = ~in;
endmodule

module TopModule (
  input in,
  output out
);
  NotGate not_gate1 (
    .in(in),
    .out(out)
  );
endmodule